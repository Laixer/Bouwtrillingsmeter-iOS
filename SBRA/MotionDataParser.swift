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
	var settings: MeasurementSettings?
	
	var exceedanceCallback: ((Int, Float) -> Void)?

	func startDataCollection(updateInterval: TimeInterval,
							 settings: MeasurementSettings?,
							 handler: @escaping MotionDataHandler) {
		
		self.settings = settings
		
		if manager.isDeviceMotionAvailable {
			manager.deviceMotionUpdateInterval = updateInterval
			var timestamp: TimeInterval = 0.0
			var shouldReset = false

			var previousFFT: [Float]?
			var previousDominantFrequency: (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)?
			var latestGravity: CMAcceleration?

			manager.startAccelerometerUpdates(to: OperationQueue.main) { (motion, error) in
				if error != nil {
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
					
					if shouldReset == true {
						self.data.removeAll()
						timestamp = 0.0
						shouldReset = false
						return
					}
					
					let speed = self.updateSpeed()
					var frequency = self.updateFrequency()
					if frequency == nil {
						frequency = previousDominantFrequency
					} else {
						previousDominantFrequency = frequency
					}
					if timestamp > 2.0 {
						shouldReset = true
						previousFFT = self.updateFFT()
					}
					
					let gravity = latestGravity
					let dataPoint = DataPoint(acceleration: motion.userAcceleration, speed: speed,
											  dominantFrequency: frequency, fft: previousFFT,
											  gravity: gravity, rotationRate: motion.rotationRate,
											  timestamp: timestamp)
					
					self.data.append(dataPoint)
					
					handler(dataPoint, nil)
					
				} else {
					handler(nil, nil)
				}
			}
		}
	}
	
	internal func stopDataCollection() {
		manager.stopAccelerometerUpdates()
		manager.stopDeviceMotionUpdates()
	}
	
	private func updateSpeed() -> Float {
		var speed = self.data.last?.speed ?? 0
		
		var xSpeed: Decimal = 0
		var ySpeed: Decimal = 0
		var zSpeed: Decimal = 0
		
		if let data = data.last {
			let xAcceleration = Decimal(data.acceleration.x)
			let yAcceleration = Decimal(data.acceleration.y)
			let zAcceleration = Decimal(data.acceleration.z)
			xSpeed += xAcceleration * 0.01
			ySpeed += yAcceleration * 0.01
			zSpeed += zAcceleration * 0.01
			
			let decimalSpeed = pow(xSpeed, 2) + pow(ySpeed, 2) + pow(zSpeed, 2)
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
				let xVelocity = velocity.0
				let yVelocity = velocity.1
				let zVelocity = velocity.2
				
				if let settings = settings {
					let xLimit = MotionDataParser.getLimitValue(frequency: xVelocity, settings: settings)
					let yLimit = MotionDataParser.getLimitValue(frequency: yVelocity, settings: settings)
					let zLimit = MotionDataParser.getLimitValue(frequency: zVelocity, settings: settings)
					
					xLimits.append(xLimit)
					yLimits.append(yLimit)
					zLimits.append(zLimit)
				}
			}
		}
		
		return calculateDominantFrequencies(limitValues: (xLimits, yLimits, zLimits))
	}

	private func calculateDominantFrequencies(limitValues: (x: [Float], y: [Float], z: [Float]))
		-> (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)? {
		let ratioX: Float = 0.0
		let ratioY: Float = 0.0
		let ratioZ: Float = 0.0
		
		var dominantX: DominantFrequency?
		var dominantY: DominantFrequency?
		var dominantZ: DominantFrequency?
		
		for index in 0..<limitValues.x.count {
			let limitValueX = limitValues.x[index]
			let limitValueY = limitValues.y[index]
			let limitValueZ = limitValues.z[index]
			let velocity = velocityInFrequencyDomain()
			
			if let velocityX = velocity?[index].x {
				dominantX = dominantFrequency(velocity: velocityX, limitValue: limitValueX, ratio: ratioX, index: index)
			}
			
			if let velocityY = velocity?[index].y {
				dominantY = dominantFrequency(velocity: velocityY, limitValue: limitValueY, ratio: ratioY, index: index)
			}
			
			if let velocityZ = velocity?[index].z {
				dominantZ = dominantFrequency(velocity: velocityZ, limitValue: limitValueZ, ratio: ratioZ, index: index)
			}
		}
		
		if let domX = dominantX, let domY = dominantY, let domZ = dominantZ {
			return (domX, domY, domZ)
		}
		
		return nil
	}
	
	func dominantFrequency(velocity: Float, limitValue: Float, ratio: Float, index: Int) -> DominantFrequency? {
		var ratio = ratio
		var dominantFrequency: Int
		if velocity / limitValue > ratio {
			ratio = velocity / limitValue
			dominantFrequency = index
			let dominantVelocity = velocity
			
			if ratio > 1.0 {
				if let callback = exceedanceCallback {
					callback(dominantFrequency, ratio)
				}
			}
			
			return DominantFrequency(frequency: dominantFrequency,
										  velocity: dominantVelocity,
										  exceedsLimit: ratio > 1.0)
		}
		
		return nil
	}
	
	private func velocityInFrequencyDomain() -> [(x: Float, y: Float, z: Float)]? {
		let acceleration = self.data.map({$0.acceleration})
		guard acceleration.count > 15 else { return nil }
		
		let xAcceleration = acceleration.map({$0.x})
		let yAcceleration = acceleration.map({$0.y})
		let zAcceleration = acceleration.map({$0.z})
		
		var velocity = [(Float, Float, Float)]()
		
		for index in 0..<xAcceleration.count {
			let acceleration = CMAcceleration(x: xAcceleration[index], y: yAcceleration[index], z: zAcceleration[index])
			
			let xVelocity = Float(acceleration.x) / Float(2) * Float.pi * Float(index)
			let yVelocity = Float(acceleration.y) / Float(2) * Float.pi * Float(index)
			let zVelocity = Float(acceleration.z) / Float(2) * Float.pi * Float(index)
			
			velocity.append((xVelocity, yVelocity, zVelocity))
		}
		
		return velocity
	}
	
	private static func getLimitValue(frequency: Float, settings: MeasurementSettings) -> Float {
		var index = 0
		let limit: [[Float]] = PowerLimit.limitForSettings(settings: settings)
		while limit[0][index + 1] < frequency && index < limit[0].count - 2 {
			index += 1
		}
		
		let xc1 = limit[0][index]
		let yc1 = limit[1][index]
		let xc2 = limit[0][index+1]
		let yc2 = limit[1][index+1]
		
		let diffX = xc2-xc1
		let diffY = yc2-yc1
		
		if diffX == 0 {
			return limit[1][index]
		}
		
		let diff = diffY/diffX
		let limitAmplitude = yc1 + diff * (frequency - xc1)
		return limitAmplitude
	}
}
