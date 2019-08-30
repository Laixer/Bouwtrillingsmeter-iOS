//
//  DataHandler.swift
//  SBRA
//
//  Created by Anonymous on 27-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation

class DataHandler {
    
    private static var currentlyMeasuring: Bool?
    private static var currentDataInterval: DataInterval?
    private static var lastCalculatedDataInterval: DataInterval?
    private static var currentDataIntervalIndex: Int?
    private static var lastExceedingIndex: Int?
    private static var indexesToBeCleared: [Int]?
    
    private static var dataIntervalClosedListeners: [DataIntervalClosedListener]?
    
    static func initialize(){
        currentlyMeasuring = false
        currentDataInterval = nil
        dataIntervalClosedListeners = []
    }
    
    public static func startMeasuring() {
        if MeasurementControl.getCurrentMeasurement() == nil {
            print("We have no current measurement object!")
            return
        }
        
        currentlyMeasuring = true
        currentDataIntervalIndex = 0
        lastExceedingIndex = -1
        indexesToBeCleared = []
        currentDataInterval = DataInterval(measurementUID: MeasurementControl.getCurrentMeasurement()!.getUID(), index: currentDataIntervalIndex!)
    }
    
    private static func onStartNewInterval(){
        currentDataInterval!.onIntervalEnd()
        performIntervalCalculation(dataInterval: currentDataInterval!)
        MeasurementControl.getCurrentMeasurement()!.addDataInterval(dataInterval: currentDataInterval!)
        
        currentDataInterval = DataInterval(measurementUID: MeasurementControl.getCurrentMeasurement()!.getUID(), index: currentDataIntervalIndex!)
        currentDataIntervalIndex!+=1
        
        triggerDataIntervalClosedEvent(dataInterval: lastCalculatedDataInterval)
    }
    
    public static func addDataIntervalClosedListener(listener: DataIntervalClosedListener?){
        if listener == nil {
            print("Listener to be added to data interval closed listeners can not be null")
            return
        }
        dataIntervalClosedListeners!.append(listener!)
    }
    
    public static func removeDataIntervalClosedListener(listener: DataIntervalClosedListener){
        for count in 0...dataIntervalClosedListeners!.count {
            if dataIntervalClosedListeners![count] === listener {
                dataIntervalClosedListeners!.remove(at: count)
                break
            }
        }
    }
    
    private static func triggerDataIntervalClosedEvent(dataInterval: DataInterval?) {
        for listener in dataIntervalClosedListeners! {
            (listener as? DataIntervalClosedListener)!.onDataIntervalClosed(dataInterval: dataInterval)
        }
    }
    
    static func isCurrentlyMeasuring() -> Bool {
        return currentlyMeasuring!
    }
    
    private static func performIntervalCalculation(dataInterval: DataInterval){
        if dataInterval.getAcceleration().count == 0 {
            print("No datapoints were added to this interval.")
            return
        }
        
        let thisDataInterval: DataInterval = dataInterval
        
        DispatchQueue.global(qos: .background).async {
            thisDataInterval.onThreadCalculationsStart()
            
            let dataIntervalStartTime: Int64 = dataInterval.getMillisStart()
            let velocities: [DataPoint] = Calculator.calculateVelocityFromAcceleration(data: thisDataInterval.getAcceleration())
            let velocitiesAbsMax: DataPoint = Calculator.calculateVelocityAbsMaxFromVelocities(time: dataIntervalStartTime, data: velocities)
            thisDataInterval.setVelocities(velocities: velocities)
            thisDataInterval.setVelocitiesAbsoluteMax(velocitiesAbsoluteMax: velocitiesAbsMax)
            
            let frequencyAmplitudes: [DataPoint<Double>] = Calculator.fft(acceleration: thisDataInterval.getAcceleration())
            thisDataInterval.setFrequencyAplitudes(frequencyAmplitudes: frequencyAmplitudes)
            
            let dominantFrequencies: DominantFrequencies = Calculator.calculateDominantFrequencies(frequencyAmplitudes: frequencyAmplitudes)
            thisDataInterval.setDominantFrequencies(dominantFrequencies: dominantFrequencies)
            
            if thisDataInterval.isExceedingLimit(){
                lastExceedingIndex = thisDataInterval.getIndex()
                // backend.onexceededlimit
            }
            
            thisDataInterval.onThreadCalculationsEnd()
            
            lastCalculatedDataInterval = thisDataInterval
        }
    }
    
    public static func onReceivedData(xLine: Float, yLine: Float, zLine: Float){
        if isCurrentlyMeasuring() && currentDataInterval != nil {
            let timePassed: Int64 = NSDate().getCurrentMillis() - currentDataInterval!.getMillisStart()
            // TODO: declare somewhere else
            let interval: Int64 = 1000
            
            if timePassed > interval {
                onStartNewInterval()
            }
            
            let startTime: Int64 = MeasurementControl.getCurrentMeasurement()!.getStartTimeInMillis()
            let currentTime: Int64 = NSDate().getCurrentMillis()
            let dataPointTime: Int64 = currentTime - startTime
            
            currentDataInterval?.addDataPoint(dataPoint: DataPoint(xAxisValue: dataPointTime, values: [xLine,yLine,zLine]))
        }
    }
    
    public static func stopMeasuring() {
        if !currentlyMeasuring! {
            print("Attempted to stop measuring when we were not measuring")
            return
        }
        
        currentlyMeasuring = false
    }
    
}

protocol DataIntervalClosedListener: class {
    func onDataIntervalClosed(dataInterval: DataInterval?)
}
