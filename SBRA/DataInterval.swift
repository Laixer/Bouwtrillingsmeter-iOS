//
//  DataInterval.swift
//  SBRA
//
//  Created by Anonymous on 27-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Charts

class DataInterval {
    
    private var measurementUID: String
    private var index: Int?
    private var millisRelativeStart: Int64?
    private var millisRelativeEnd: Int64?
    
    private var acceleration: [DataPoint<Int64>]?
    private var velocities: [DataPoint<Int64>]?
    private var velocitiesAbsoluteMax: DataPoint<Int64>?
    private var frequencyAmplitudes: [DataPoint<Double>]?
    private var dominantFrequencies: DominantFrequencies?

    private var lockedByThread: Bool?
    
    init(measurementUID: String, index: Int) {
        self.measurementUID = measurementUID
        self.index = index
        
        acceleration = [DataPoint]()
        millisRelativeStart = NSDate().getCurrentMillis()
    }
    
    func addDataPoint(dataPoint: DataPoint<Int64>){
        acceleration?.append(dataPoint)
    }
    
    func onIntervalEnd() {
        millisRelativeEnd = NSDate().getCurrentMillis() - millisRelativeStart!
    }
    
    func onThreadCalculationsStart(){
        lockedByThread = true
    }
    
    func onThreadCalculationsEnd(){
        lockedByThread = false
    }
    
    func attemptDeleteDataPoints() -> Bool {
        if lockedByThread! {
            return false
        }
        acceleration!.removeAll()
        return true
    }
    
    func isExceedingLimit() -> Bool {
        for bool in dominantFrequencies!.getExceedsLimit(){
            if bool {
                return true
            }
        }
        return false
    }
    
    func getDominantFrequenciesAsDataPoints() -> [DataPoint<Int64>] {
        return [DataPoint(xAxisValue: millisRelativeStart!, values: dominantFrequencies!.getVelocities())]
    }
    
    func getExceedingAsDataPoints() -> [DataPoint<Double>] {
        
        var result: [DataPoint<Double>] = []
        
        for dimension in 0..<3 {
            var frequency: Double = -1
            var velocities: [Float] = [-1.0, -1.0, -1.0]
            
            if dominantFrequencies!.getExceedsLimit()[dimension] {
                frequency = Double(dominantFrequencies!.getFrequencies()[dimension])
                velocities[0] = dominantFrequencies!.getVelocities()[dimension]
            }
            
            result.append(DataPoint<Double>(xAxisValue: frequency, values: velocities))
            
        }
        
        return result
        
    }
    
    func getAllDominantFrequenciesAsEntries() -> [ChartDataEntry] {
        
        var result: [ChartDataEntry] = []
        
        let frequencies = dominantFrequencies!.getFrequencies()
        let velocities = dominantFrequencies!.getVelocities()
        for dimension in 0..<3 {
            result.append(ChartDataEntry(x: Double(frequencies[dimension]), y: Double(velocities[dimension])))
        }
        
        return result
    }
    
    func getVelocitiesAbsMaxAsDataPoints() -> [DataPoint<Int64>] {
        var result: [DataPoint<Int64>] = []
        velocitiesAbsoluteMax!.xAxisValue = millisRelativeStart!
        result.append(velocitiesAbsoluteMax!)
        return result
    }
    
    func setVelocities(velocities: [DataPoint<Int64>]){
        if self.velocities == nil {
            self.velocities = velocities
        } else {
            print("Cannot change velocities once they have been set.")
            return
        }
    }
    
    func setVelocitiesAbsoluteMax(velocitiesAbsoluteMax: DataPoint<Int64>){
        if self.velocitiesAbsoluteMax == nil {
            self.velocitiesAbsoluteMax = velocitiesAbsoluteMax
        } else {
            print("Cannot change absolute max velocities once they have been set.")
            return
        }
    }
    
    func setFrequencyAplitudes(frequencyAmplitudes: [DataPoint<Double>]) {
        if self.frequencyAmplitudes == nil {
            self.frequencyAmplitudes = frequencyAmplitudes
        } else {
            print("Cannot change frequency amplitudes once they have been set.")
            return
        }
    }
    
    func setDominantFrequencies(dominantFrequencies: DominantFrequencies){
        if self.dominantFrequencies == nil {
            self.dominantFrequencies = dominantFrequencies
        } else {
            print("Cannot change dominant frequencies once they have been set.")
            return
        }
    }
    
    func getAcceleration() -> [DataPoint<Int64>] {
        return acceleration!
    }
    
    func getIndex() -> Int {
        return index!
    }
    
    func getMillisStart() -> Int64 {
        return millisRelativeStart!
    }
    
    func getFrequencyAmplitudes() -> [DataPoint<Double>] {
        return frequencyAmplitudes!
    }
    
}
