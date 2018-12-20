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

typealias MotionDataHandler = (DataPoint?, Error?) -> Void

class MotionDataParser: NSObject {
	
	let manager = CMMotionManager()
	var data = [DataPoint]()
	lazy var setup = {
		return vDSP_create_fftsetup(UInt(ceil(log2(10000.0))), 0)
	}()
	//var speedValues = [Float]()
	
	func startDataCollection(updateInterval: TimeInterval, handler: @escaping MotionDataHandler) {
		if (manager.isDeviceMotionAvailable) {
			manager.deviceMotionUpdateInterval = updateInterval
			var timestamp: TimeInterval = 0.0
			manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
				if error != nil {
					handler(nil, error)
				}
				
				if let motion = motion {
					timestamp += updateInterval
					let speed = self.updateSpeed()
					let frequency = self.updateFrequency()
					let fft = Float(0.0)
					let gravity = Float(0.0)
					let dataPoint = DataPoint(acceleration: motion.userAcceleration, speed: speed, frequency: frequency, fft: fft, gravity: gravity, rotationRate: motion.rotationRate, timestamp: timestamp)
					
					self.data.append(dataPoint)
					
					//self.speedValues.append(self.updateSpeed())
					handler(dataPoint, nil)
					
				} else {
					handler(nil, nil)
				}
			}
		}
	}
	
	private func updateSpeed() -> Float {
		var speed = self.data.last?.speed ?? 0
		
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
			return speed
		}
		
		return 0.0
	}
	
	private func updateFrequency() -> [Float] {
		
		let speeds = self.data.map({$0.speed})
		
		//print("speeds: \(speeds)")
		
		if speeds.count > 20 {
			return Surge.fft(speeds)
		}
		
		return [0.0]
	}
	
	
}
