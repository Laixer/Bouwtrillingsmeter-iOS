//
//  MotionDataParser.swift
//  SBRA
//
//  Created by Wander Siemers on 24/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

//swiftlint:disable identifier_name
//swiftlint:disable line_length


import UIKit
import CoreMotion
import Accelerate
import Surge

typealias MotionDataHandler = (Error?) -> Void

class MotionDataParser: NSObject {

	let manager = CMMotionManager()
	var settings: MeasurementSettings?
    var graphPageView: GraphPageViewController?

    func startDataCollection(updateInterval: TimeInterval) {

        if manager.isDeviceMotionAvailable {
            
            manager.deviceMotionUpdateInterval = updateInterval
            
            manager.startDeviceMotionUpdates(to: .main) { (motion, err) in
                let x = motion!.userAcceleration.x * 9.81
                let y = motion!.userAcceleration.y * 9.81
                let z = motion!.userAcceleration.z * 9.81
                DataHandler.onReceivedData(xLine: Float(x), yLine: Float(y), zLine: Float(z))
            }
        }
    }
    
    internal func stopDataCollection() {
        manager.stopAccelerometerUpdates()
        manager.stopDeviceMotionUpdates()
    }
}
