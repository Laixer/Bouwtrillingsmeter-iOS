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
	var speed: Float = 0.0
	var dominantFrequency: (x: DominantFrequency, y: DominantFrequency, z: DominantFrequency)?
	var fft: [Float]?
	var gravity: CMAcceleration?
	var rotationRate: CMRotationRate = CMRotationRate(x: 0, y: 0, z: 0)
	var timestamp: TimeInterval = 0
	
	func toDataPoint() -> DataPoint {
		let dataPoint = DataPoint(acceleration: acceleration,
								  speed: speed,
								  dominantFrequency: dominantFrequency,
								  fft: fft,
								  gravity: gravity,
								  rotationRate: rotationRate,
								  timestamp: timestamp)
		
		return dataPoint
	}
	
	class func fromDataPoint(dataPoint: DataPoint) -> PersistableDataPoint {
		let persistable = PersistableDataPoint()
		
		persistable.acceleration = dataPoint.acceleration
		persistable.speed = dataPoint.speed
		persistable.dominantFrequency = dataPoint.dominantFrequency
		persistable.fft = dataPoint.fft
		persistable.gravity = dataPoint.gravity
		persistable.rotationRate = dataPoint.rotationRate
		persistable.acceleration = dataPoint.acceleration
		
		return persistable
	}
}
