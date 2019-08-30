//
//  Measurement.swift
//  SBRA
//
//  Created by Wander Siemers on 06/03/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import RealmSwift
import CoreLocation

/*
    the measurement object that collects all necessary data about the take nmeasurement
 
    objects with 'dynamic' are stored in the phones db
*/

class Measurement: Object {
    
    @objc dynamic var uid: String = UUID().uuidString
    @objc dynamic var name: String = "Meting op onbekende locatie"
    @objc dynamic var dateStart: Date?
    @objc dynamic var dateEnd: Date?
    var longitude: Double = DBL_MAX
    var latitude: Double = DBL_MAX
    var locationAccuracy: Double?
    // address = locationString
    var locationString: String?
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
    
    private var placemark: CLPlacemark?
    
    func addDataInterval(dataInterval: DataInterval){
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
    
    func close(){
        dateEnd = Date()
        closed = true
        getLocation()
        locationString = placemark?.locality
        if let lat = placemark?.location?.coordinate.latitude {
            latitude = Double(lat)
        }
        
        if let long = placemark?.location?.coordinate.longitude {
            longitude = Double(long)
        }
    }
    
    public func getStartTimeInMillis() -> Int64 {
        return Int64(dateStartObject!.timeIntervalSince1970 * 1000)
    }
    
    public func getUID() -> String {
        return uid
    }
    
    private func getLocation() {
        let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("ERROR: Can't retrieve location, reason: location services are disabled")
            return
        }
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
    
}

extension Measurement: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let coder = CLGeocoder()
        
        if let location = locations.last {
            coder.reverseGeocodeLocation(location) { [weak weakSelf = self] (placemarks, error) in
                weakSelf?.placemark = placemarks?.first
                
                if let error = error {
                    print(error)
                }
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        } else {
            print("error: not authorized to retrieve location")
        }
    }
}
