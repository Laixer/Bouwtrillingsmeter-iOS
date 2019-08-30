//
//  MotionDataParser.swift
//  SBRA
//
//  Created by Wander Siemers on 24/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

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

            manager.startAccelerometerUpdates(to: OperationQueue.main) { (motion, error) in
                if error != nil {
                    return
                }
            }

            manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
                if error != nil {
                    return
                }

                if let motion = motion {
                    DataHandler.onReceivedData(xLine: Float(motion.userAcceleration.x), yLine: Float(motion.userAcceleration.y), zLine: Float(motion.userAcceleration.z))
                } else {
                    return
                }
            }
        }
    }
    
    internal func stopDataCollection() {
        manager.stopAccelerometerUpdates()
        manager.stopDeviceMotionUpdates()
    }
}
