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
	let rotationRate: CMRotationRate
	let timestamp: TimeInterval
}
