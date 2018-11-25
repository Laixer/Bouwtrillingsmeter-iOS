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
	var speedValues = [Float]()
	
	func startDataCollection(handler: @escaping MotionDataHandler) {
		if (manager.isDeviceMotionAvailable) {
			let interval = 0.01
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
					self.updateSpeed()
					handler(dataPoint, nil)
					
				} else {
					handler(nil, nil)
				}
			}
		}
	}
	
	private func updateSpeed() {
		var speed = self.speedValues.last ?? 0
		
		var vx: Decimal = 0
		var vy: Decimal = 0
		var vz: Decimal = 0
		
		if let data = data.last {
			let ax = Decimal(data.acceleration.x)
			let ay = Decimal(data.acceleration.y)
			let az = Decimal(data.acceleration.z)
			vx += ax * 0.01
			vy += ay * 0.01
			vz += az * 0.01
			
			
			let decimalSpeed = pow(vx, 2) + pow(vy, 2)
			speed += Float(sqrt(Double(truncating: decimalSpeed as NSNumber)))
			speedValues.append(speed)
		}
	}
	
	
}
