//
//  PersistableMeasurement.swift
//  SBRA
//
//  Created by Wander Siemers on 30/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class PersistableMeasurement: Object {
    let dataPoints = RealmSwift.List<PersistableDataPoint>()
	@objc dynamic var date: Date = Date.init(timeIntervalSinceReferenceDate: 0)
	let latCoordinate =  RealmOptional<Float>()
	let longCoordinate = RealmOptional<Float>()
	@objc dynamic var locationString: String?
	var exceededLimit = false
	@objc var measurementID = UUID().uuidString
	
	func toMeasurement() -> Measurement {
		let measurement = Measurement(dataPoints: dataPoints.map({$0.toDataPoint()}),
									  date: date,
									  latCoordinate: latCoordinate.value,
									  longCoordinate: longCoordinate.value,
									  locationString: locationString,
									  exceededLimit: exceededLimit,
                                      persistableMeasurement: self, description: "description")
		return measurement
	}
	
	override class func primaryKey() -> String? {
		return "measurementID"
	}
}
