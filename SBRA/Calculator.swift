//
//  Calculator.swift
//  SBRA
//
//  Created by Anonymous on 27-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Accelerate
import Surge

class Calculator {
    
    private static var accelerationPrevious: DataPoint<Int64>?
    private static var velocity: [Float]?
    private static var yv: Float = 0
    private static var yt: Float = 0
    private static var limitValuesAsFloatPoints:[[Float]]?
    
    // start measurring with default values
    static func onStartMeasurementCalculations(settings: MeasurementSettings) {
        accelerationPrevious = DataPoint(xAxisValue: 0, values: [0,0,0])
        velocity = [0,0,0]
        
        
        limitValuesAsFloatPoints = PowerLimit.limitForSettings(settings: settings)
    }
    
    static func calculateVelocityFromAcceleration(data: [DataPoint<Int64>]) -> [DataPoint<Int64>] {
        var result: [DataPoint<Int64>] = []
        var timePrevious: Double = 0
        velocity = [0,0,0]
        
        for count in 0..<data.count {
            
            let timeCurrent: Double = Double(data[count].xAxisValue)
            let dtSeconds: Double = (timeCurrent - timePrevious) / 1000
            
            velocity![0] += data[count].values[0] * Float(dtSeconds)
            velocity![1] += data[count].values[1] * Float(dtSeconds)
            velocity![2] += data[count].values[2] * Float(dtSeconds)
            
            result.append(DataPoint(xAxisValue: data[count].xAxisValue, values: velocity!))
            
            timePrevious = timeCurrent
            
        }
        
        return result
    }
    
    static func calculateVelocityAbsMaxFromVelocities(time: Int64, data: [DataPoint<Int64>]) -> DataPoint<Int64> {
        var absMaxIndexes: [Int] = getAbsMaxIndexesInArray3D(dataPoints: data)
        var values: [Float] = []
        for dimension in 0..<3 {
            values.insert(abs(data[absMaxIndexes[dimension]].values[dimension]), at: dimension)
        }
        return DataPoint(xAxisValue: time, values: values)
    }
    
    private static func getAbsMaxIndexesInArray3D<T>(dataPoints: [DataPoint<T>]) -> [Int] {
        var highestValue: [Float] = [Float.leastNormalMagnitude, Float.leastNormalMagnitude, Float.leastNormalMagnitude]
        var index: [Int] = [-1,-1,-1]
        
        for count in 0..<dataPoints.count {
            for dimension in 0..<3 {
                let value: Float = abs(dataPoints[count].values[dimension])
                if value > highestValue[dimension] {
                    highestValue[dimension] = value
                    index[dimension] = count
                }
            }
        }
        
        return index
    }
    
    // TODO const interval
    static func fft(acceleration: [DataPoint<Int64>]) -> [DataPoint<Double>] {
        let accelerationCount = acceleration.count
        let sampleRate: Double = Double(accelerationCount) / (1000 / 1000)
        
        var accelerationSplit: [[Float]] = [[]]
        accelerationSplit.insert([], at: 0)
        accelerationSplit.insert([], at: 1)
        accelerationSplit.insert([], at: 2)
        
        for count in 0..<acceleration.count {
            accelerationSplit[0].insert(acceleration[count].values[0], at: count)
            accelerationSplit[1].insert(acceleration[count].values[1], at: count)
            accelerationSplit[2].insert(acceleration[count].values[2], at: count)
        }
        
        // use surge to implement fft
//        var fft: TempiFFT = TempiFFT(withSize: 4, sampleRate: Float(sampleRate))
//        fft.fftForward(accelerationSplit[0])
//        fft.fftForward(accelerationSplit[1])
//        fft.fftForward(accelerationSplit[2])

        accelerationSplit[0] = Surge.fft(accelerationSplit[0])
        accelerationSplit[1] = Surge.fft(accelerationSplit[1])
        accelerationSplit[2] = Surge.fft(accelerationSplit[2])
        
        var magnitude: [Float] = []
        var result: [DataPoint<Double>] = []
        
        for count in 0..<accelerationCount/2 {
            for dimension in 0..<3 {
                let re: Double = Double(accelerationSplit[dimension][2 * count])
                let im: Double = Double(accelerationSplit[dimension][2 * count + 1])
                magnitude.insert(Float(hypot(im, re)), at: dimension)
            }
            let frequency: Double = (sampleRate * Double(count)) / (Double(accelerationCount))
            result.append(DataPoint(xAxisValue: frequency, values: magnitude))
        }
        return result
        
    }
    
    // Create a new dominant frequency with the given fft data
    static func calculateDominantFrequencies(frequencyAmplitudes: [DataPoint<Double>]) -> DominantFrequencies{
        var maxIndexes: [Int] = [0,0,0]
        for dimension in 0..<3 {
            var highestRatio: Float = 0
            for count in 1..<frequencyAmplitudes.count - 1 {
                let xAxisValue: Double = frequencyAmplitudes[count].xAxisValue
                let frequency: Float = Float(xAxisValue)
                let amplitude: Float = frequencyAmplitudes[count].values[dimension]
                
                if amplitude > frequencyAmplitudes[count-1].values[dimension] && amplitude > frequencyAmplitudes[count + 1].values[dimension]{
                    let limitAmplitude = getLimitAmplitudeFromFrequency(frequency: frequency)
                    let ratio: Float = amplitude / limitAmplitude
                    
                    if ratio > highestRatio {
                        highestRatio = ratio
                        maxIndexes[dimension] = count
                    }
                }
            }
        }
        
        var maxAmplitudes: [Float] = []
        var maxFrequencies: [Float] = []
        var exceeded: [Bool] = []
        
        for dimension in 0..<3 {
            let xAxisValue: Double = frequencyAmplitudes[maxIndexes[dimension]].xAxisValue
            maxFrequencies.insert(Float(xAxisValue), at: dimension)
            maxAmplitudes.insert(frequencyAmplitudes[maxIndexes[dimension]].values[dimension], at: dimension)
            exceeded.insert(maxAmplitudes[dimension] > getLimitAmplitudeFromFrequency(frequency: maxFrequencies[dimension]), at: dimension)
        }
        
        return DominantFrequencies(frequencies: maxFrequencies, velocities: maxAmplitudes, exceedsLimit: exceeded)
    }
    
    private static func getLimitAmplitudeFromFrequency(frequency: Float) -> Float {
        var index = 0
        while limitValuesAsFloatPoints![0][index + 1] < frequency && index < limitValuesAsFloatPoints![0].count - 2 {
            index += 1
        }

        let xc1 = limitValuesAsFloatPoints![0][index]
        let yc1 = limitValuesAsFloatPoints![1][index]
        let xc2 = limitValuesAsFloatPoints![0][index+1]
        let yc2 = limitValuesAsFloatPoints![1][index+1]

        let diffX = xc2-xc1
        let diffY = yc2-yc1

        if diffX == 0 {
            return limitValuesAsFloatPoints![1][index]
        }

        let diff = diffY/diffX
        let limitAmplitude = yc1 + diff * (frequency - xc1)
        return limitAmplitude
    }
    
}