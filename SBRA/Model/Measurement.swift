//
//  Measurement.swift
//  SBRA
//
//  Created by Wander Siemers on 06/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import RealmSwift
import CoreLocation
import Contacts

/*
    the measurement object that collects all necessary data about the take nmeasurement
 
    objects with '@objc dynamic' are stored in the phones db
*/

// swiftlint:disable identifier_name

class Measurement: Object {
    
    @objc dynamic var uid: String = UUID().uuidString
    @objc dynamic var name: String = "Meting op onbekende locatie"
    @objc dynamic var dateStart: Date?
    @objc dynamic var dateEnd: Date?
    @objc dynamic var exceededText: String = "Geen overschrijdingen"
    var longitude: Double = Double.greatestFiniteMagnitude
    var latitude: Double = Double.greatestFiniteMagnitude
    var locationAccuracy: Double?
    var locationString: String?
    @objc dynamic var address: String?
    override var description: String {
        return "Voeg een beschrijving toe"
    }
    var settings: MeasurementSettings? = nil
    var dataIntervalCount: Int = 0
    
    var dataIntervals: [DataInterval] = []
    // bitmap
    
    private var dateStartObject: Date?
    private var open: Bool = false
    private var closed: Bool = false
    private var bitmapFileName: String?
    
    func addDataInterval(dataInterval: DataInterval) {
        if closed {
            print("Current measurement is already closed! No more data can be added.")
            return
        }
        
        dataIntervals.append(dataInterval)
        dataIntervalCount = dataIntervals.count
    }
    
    func start() {
        dateStartObject = Date()
        dateStart = dateStartObject!
        open = true
    }
    
    func close(placemark: CLPlacemark?) {
        dateEnd = Date()
        closed = true
        
        locationString = placemark?.locality
        if let lat = placemark?.location?.coordinate.latitude {
            latitude = Double(lat)
        }
        
        if let long = placemark?.location?.coordinate.longitude {
            longitude = Double(long)
        }
        if locationString != nil {
            self.name = "Meting in " + locationString!
        }
        
        var address = CNPostalAddressFormatter.string(from:placemark!.postalAddress!, style: .mailingAddress)
        address = address.replacingOccurrences(of: "\n", with: ", ")
        
        self.address = address
        
        for dataInterval in self.dataIntervals {
            if dataInterval.isExceedingLimit() {
                self.exceededText = "Overschrijdingen gedetecteerd"
                break
            }
        }
        
        Database().addMeasurement(measurement: self)
        
    }
    
    public func getStartTimeInMillis() -> Int64 {
        return Int64(dateStartObject!.timeIntervalSince1970 * 1000)
    }
    
    public func getUID() -> String {
        return uid
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["longitude", "latitude", "locationAccuracy", "locationString", "settings", "dataIntervalCount", "dataIntervalCount", "dateStartObject", "open", "closed", "bitmapFileName"]
    }
    
}
