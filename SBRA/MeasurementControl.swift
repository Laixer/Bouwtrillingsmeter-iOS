//
//  MeasurementControl.swift
//  SBRA
//
//  Created by Anonymous on 28-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import CoreLocation

class MeasurementControl {
    
    private static var currentMeasurement: Measurement?
    private static var lastMeasurement: Measurement?
    private static var allMeasurements: [Measurement] = []
    
    static func getCurrentMeasurement() -> Measurement? {
        return currentMeasurement
    }
    
    static func getLastMeasurement() -> Measurement? {
        return lastMeasurement
    }
    
    static func getAllMeasurements() -> [Measurement]{
        return allMeasurements
    }
    
    static func createNewMeasurement() {
        currentMeasurement = Measurement()
    }
    
    static func onFinishMeasurement(placemark: CLPlacemark?) {
        currentMeasurement!.close(placemark: placemark)
        lastMeasurement = currentMeasurement!
        allMeasurements.append(currentMeasurement!)
    }
    
}
