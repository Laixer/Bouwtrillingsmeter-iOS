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
	
	func startDataCollection(updateInterval: TimeInterval,
							 handler: @escaping MotionDataHandler) {
		if (manager.isDeviceMotionAvailable) {
			manager.deviceMotionUpdateInterval = updateInterval
			var timestamp: TimeInterval = 0.0
			var shouldReset = false
			
			var previousFFT: [Float]?
			var previousDominantFrequency: (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)?
			var latestGravity: CMAcceleration?
			
			manager.startAccelerometerUpdates(to: OperationQueue.main) { (motion, error) in
				if (error != nil) {
					return
				}
				
				if let motion = motion {
					latestGravity = motion.acceleration
				}
			
			}
			
			manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
				if error != nil {
					handler(nil, error)
				}
				
				if let motion = motion {
					timestamp += updateInterval
					
					if (shouldReset == true) {
						self.data.removeAll()
						timestamp = 0.0
						shouldReset = false
						return
					}
					
					let speed = self.updateSpeed()
					var frequency = self.updateFrequency()
					if (frequency == nil) {
						frequency = previousDominantFrequency
					} else {
						previousDominantFrequency = frequency
					}
					if (timestamp > 2.0) {
						shouldReset = true
						previousFFT = self.updateFFT()
					}
					
					let gravity = latestGravity
					let dataPoint = DataPoint(acceleration: motion.userAcceleration,
											  speed: speed,
											  dominantFrequency:frequency,
											  fft: previousFFT,
											  gravity: gravity,
											  rotationRate: motion.rotationRate,
											  timestamp: timestamp)
					
					self.data.append(dataPoint)
					
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
			
			
			let decimalSpeed = pow(vx, 2) + pow(vy, 2) + pow(vz, 2)
			speed += Float(sqrt(Double(truncating: decimalSpeed as NSNumber)))
			return speed
		}
		
		return 0.0
	}
	
	private func updateFFT() -> [Float]? {
		
		let speed = self.data.map({$0.speed})
		
		guard speed.count > 10 else { return nil }
		
		return Surge.fft(speed)
	}
	
	private func updateFrequency() -> (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)? {
		
		let velocityFrequencyDomain = velocityInFrequencyDomain()
		
		var xLimits = [Float]()
		var yLimits = [Float]()
		var zLimits = [Float]()
		
		if let velocities = velocityFrequencyDomain {
			for velocity in velocities {
				let x = velocity.0
				let y = velocity.1
				let z = velocity.2
				
				let xLimit = MotionDataParser.getLimitValue(frequency: x)
				let yLimit = MotionDataParser.getLimitValue(frequency: y)
				let zLimit = MotionDataParser.getLimitValue(frequency: z)
				
				xLimits.append(xLimit)
				yLimits.append(yLimit)
				zLimits.append(zLimit)
				
			}
		}
		
		return calculateDominantFrequencies(limitValues: (xLimits, yLimits, zLimits))
	}
	
	
	private func calculateDominantFrequencies(limitValues: (x: [Float], y: [Float], z: [Float])) -> (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)? {
		var dominantFrequencyX: Int
		var ratioX: Float = 0.0
		var dominantVelocityX: Float
		
		var dominantFrequencyY: Int
		var ratioY: Float = 0.0
		var dominantVelocityY: Float
		
		var dominantFrequencyZ: Int
		var ratioZ: Float = 0.0
		var dominantVelocityZ: Float
		
		
		var x: DominantFrequency?
		var y: DominantFrequency?
		var z: DominantFrequency?
		
		for i in 0..<limitValues.x.count {
			let limitValueX = limitValues.x[i]
			let limitValueY = limitValues.y[i]
			let limitValueZ = limitValues.z[i]
			let velocity = velocityInFrequencyDomain()
			
			if let velocityX = velocity?[i].x {
				if (velocityX / limitValueX > ratioX) {
					ratioX = velocityX / limitValueX
					dominantFrequencyX = i
					dominantVelocityX = velocityX
					
					x = DominantFrequency(frequency: dominantFrequencyX, velocity: dominantVelocityX, exceedsLimit: ratioX > 1.0)
				}
			}
			
			if let velocityY = velocity?[i].y {
				if (velocityY / limitValueY > ratioY) {
					ratioY = velocityY / limitValueY
					dominantFrequencyY = i
					dominantVelocityY = velocityY
					
					y = DominantFrequency(frequency: dominantFrequencyY, velocity: dominantVelocityY, exceedsLimit: ratioY > 1.0)
				}
			}
			
			if let velocityZ = velocity?[i].z {
				if (velocityZ / limitValueZ > ratioZ) {
					ratioZ = velocityZ / limitValueZ
					dominantFrequencyZ = i
					dominantVelocityZ = velocityZ
					
					z = DominantFrequency(frequency: dominantFrequencyZ, velocity: dominantVelocityZ, exceedsLimit: ratioZ > 1.0)
				}
			}
		}
		
		if let x = x, let y = y, let z = z {
			//print("dom x: \(x) dom y: \(y) dom z: \(z)")
			return (x, y, z)
		}
		
		return nil
	}
	
	
	private func velocityInFrequencyDomain() -> [(x: Float, y: Float, z: Float)]?  {
		let acceleration = self.data.map({$0.acceleration})
		guard acceleration.count > 15 else { return nil }
		
		let xAcceleration = acceleration.map({$0.x})
		let yAcceleration = acceleration.map({$0.y})
		let zAcceleration = acceleration.map({$0.z})
		

		
		var velocity = [(Float, Float, Float)]()
		
		for i in 0..<xAcceleration.count {
			let acceleration = CMAcceleration(x: xAcceleration[i], y: yAcceleration[i], z: zAcceleration[i])
			
			
			let x = Float(acceleration.x) / Float(2) * Float.pi * Float(i)
			let y = Float(acceleration.y) / Float(2) * Float.pi * Float(i)
			let z = Float(acceleration.z) / Float(2) * Float.pi * Float(i)
			
			velocity.append((x, y, z))
		}
		
		return velocity
	}
	
	private static func getLimitValue(frequency: Float) -> Float {
		return 35.0
	}
}
