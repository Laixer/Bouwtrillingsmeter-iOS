//
//  DataPoint.swift
//  SBRA
//
//  Created by Wander Siemers on 24/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import CoreMotion

struct DataPoint {
	let acceleration: CMAcceleration
	let speed: Float
	let frequency: [DominantFrequency]?
	let fft: [Float]?
	let gravity: Float
	let rotationRate: CMRotationRate
	let timestamp: TimeInterval
}
