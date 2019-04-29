//
//  Database.swift
//  SBRA
//
//  Created by Wander Siemers on 30/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
	func numberOfMeasurements() -> Int {
		do {
			let realm = try Realm()
			return realm.objects(PersistableMeasurement.self).count
		} catch {
			print("turnup " + error.localizedDescription)
		}
		
		return 0
	}
	
	func addMeasurement(measurement: Measurement) {
		do {
			let realm = try Realm()
			let persistable = PersistableMeasurement.fromMeasurement(measurement: measurement)
			try realm.write {
				realm.add(persistable)
			}
			print("added measurement to db")
		} catch {
			print("error adding measurement: " + error.localizedDescription)
		}
	}
	
	var measurements: [Measurement] {
		do {
			let realm = try Realm()
			let objs: Results<PersistableMeasurement> = realm.objects(PersistableMeasurement.self)
			
			return objs.map({$0.toMeasurement()})
		} catch {
			print("error adding measurement: " + error.localizedDescription)
		}
		
		return [Measurement]()
	}
	
	func removeMeasurement(measurement: Measurement) {
		if let persistable = measurement.persistableMeasurement {
			do {
				let realm = try Realm()
				try realm.write {
					realm.delete(persistable)
					
				}
			} catch {
				print("error deleting measurement: " + error.localizedDescription)
			}
		}
		
	}
}
