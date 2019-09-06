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
			return realm.objects(Measurement.self).count
		} catch {
			print("turnup " + error.localizedDescription)
		}
		
		return 0
	}
	
	func addMeasurement(measurement: Measurement) {
		do {
			let realm = try Realm()
			try realm.write {
				realm.add(measurement)
			}
			print("added measurement to db")
		} catch {
			print("error adding measurement: " + error.localizedDescription)
		}
	}
	
	var measurements: [Measurement] {
		do {
			let realm = try Realm()
			let objs: Results<Measurement> = realm.objects(Measurement.self)
			
			return objs.map({$0}).reversed()
		} catch {
			print("error adding measurement: " + error.localizedDescription)
		}
		
		return [Measurement]()
	}
	
	func removeMeasurement(measurement: Measurement) {do {
        let realm = try Realm()
        try realm.write {
            realm.delete(measurement)
            }
        } catch {
            print("error deleting measurement: " + error.localizedDescription)
        }
	}
}
