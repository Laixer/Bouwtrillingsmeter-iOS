//
//  Measurement.swift
//  SBRA
//
//  Created by Wander Siemers on 06/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import CoreLocation

struct Measurement {
	var dataPoints: [DataPoint]
	var date: Date
	var placemark: CLPlacemark?
}
