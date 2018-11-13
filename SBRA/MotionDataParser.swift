//
//  MotionDataParser.swift
//  SBRA
//
//  Created by Wander Siemers on 24/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import CoreMotion

typealias MotionDataHandler = (DataPoint?, Error?) -> Void

class MotionDataParser: NSObject {
	
	let manager = CMMotionManager()
	var data = [DataPoint]()
	
	func startDataCollection(handler: @escaping MotionDataHandler) {
		if (manager.isDeviceMotionAvailable) {
			let interval = 0.1
			manager.deviceMotionUpdateInterval = interval
			var timestamp: TimeInterval = 0.0
			manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
				if error != nil {
					handler(nil, error)
				}
				
				if let motion = motion {
					timestamp += interval
					let dataPoint = DataPoint(acceleration: motion.userAcceleration, rotationRate: motion.rotationRate, timestamp: timestamp)
					self.data.append(dataPoint)
					handler(dataPoint, nil)
					
				} else {
					handler(nil, nil)
				}
			}
		}
	}
}
