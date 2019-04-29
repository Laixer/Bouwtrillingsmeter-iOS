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
	dynamic let dataPoints = RealmSwift.List<PersistableDataPoint>()
	@objc dynamic var date: Date = Date.init(timeIntervalSinceReferenceDate: 0)
	let latCoordinate =  RealmOptional<Float>()
	let longCoordinate = RealmOptional<Float>()
	@objc dynamic var locationString: String?
	
	func toMeasurement() -> Measurement {
		let measurement = Measurement(dataPoints: dataPoints.map({$0.toDataPoint()}),
									  date: date,
									  latCoordinate: latCoordinate.value,
									  longCoordinate: longCoordinate.value,
									  locationString: locationString)
		return measurement
	}
	
	class func fromMeasurement(measurement: Measurement) -> PersistableMeasurement {
		let persistable = PersistableMeasurement()
		persistable.dataPoints.append(objectsIn: measurement.dataPoints.map({
			PersistableDataPoint.fromDataPoint(dataPoint: $0)
		}))
		persistable.date = measurement.date
		persistable.latCoordinate.value = measurement.latCoordinate
		persistable.longCoordinate.value = measurement.longCoordinate
		persistable.locationString = measurement.locationString
		
		return persistable
	}
}
