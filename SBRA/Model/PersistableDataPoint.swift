//
//  PersistableDataPoint.swift
//  SBRA
//
//  Created by Wander Siemers on 30/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import RealmSwift
import CoreMotion

class PersistableDataPoint: Object {
	var acceleration: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
	var speedX: Float = 0.0
	var speedY: Float = 0.0
	var speedZ: Float = 0.0
	var dominantFrequency: (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)?
	var fftX: [Float]?
	var fftY: [Float]?
	var fftZ: [Float]?
	var gravity: CMAcceleration?
	var rotationRate: CMRotationRate = CMRotationRate(x: 0, y: 0, z: 0)
	var timestamp: TimeInterval = 0
	
	func toDataPoint() -> DataPoint {
		let dataPoint = DataPoint(acceleration: acceleration,
								  speed: (speedX, speedY, speedZ),
								  dominantFrequency: dominantFrequency,
								  fft: (x: fftX, y: fftY, z: fftZ),
								  gravity: gravity,
								  rotationRate: rotationRate,
								  timestamp: timestamp)
		
		return dataPoint
	}
	
	class func fromDataPoint(dataPoint: DataPoint) -> PersistableDataPoint {
		let persistable = PersistableDataPoint()
		
		persistable.acceleration = dataPoint.acceleration
		persistable.speedX = dataPoint.speed.x
		persistable.speedY = dataPoint.speed.y
		persistable.speedZ = dataPoint.speed.z
		persistable.dominantFrequency = dataPoint.dominantFrequency
		persistable.fftX = dataPoint.fft.x
		persistable.fftY = dataPoint.fft.y
		persistable.fftZ = dataPoint.fft.z
		persistable.gravity = dataPoint.gravity
		persistable.rotationRate = dataPoint.rotationRate
		persistable.acceleration = dataPoint.acceleration
		
		return persistable
	}
}
