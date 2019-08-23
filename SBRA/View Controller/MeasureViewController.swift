//
//  MeasureViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 25/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import CoreLocation

class MeasureViewController: UIViewController {
    
    private var graphPageViewController: GraphPageViewController?
	
	private var showingGraphs = false
	private var indicator = UIActivityIndicatorView(style: .gray)
	private var measuringLabel = UILabel()
	
	private let numberOfGraphs = 5
	private var dataPoints = [DataPoint]()
	private var completionHandler: ((Measurement) -> Void)?
	private var locationManager: CLLocationManager?
	private var placemark: CLPlacemark?
	private var exceededLimit = false
	
	private var settings: MeasurementSettings?
	
	private let motionDataParser = MotionDataParser()
	
	private var updateHandler: MotionDataHandler?
    
    private var tempView: UIView?
	
	init(settings: MeasurementSettings?) {
        
		self.settings = settings
		motionDataParser.settings = settings
		
		super.init(nibName: nil, bundle: nil)
		
		motionDataParser.exceedanceCallback = { [weak self] (frequency, ratio) in
			print("exceeded limit \(ratio) with dom freq: \(frequency)")
			self?.exceededLimit = true
		}
		
		let saveButton = UIBarButtonItem(title: "Sla op", style: .done, target: self, action: #selector(tappedSaveButton))
		
		navigationItem.title = "Meting"
		
		navigationItem.rightBarButtonItem = saveButton
        
	}
	
	override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.init(settings: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func setupGraphs(){

        graphPageViewController = GraphPageViewController()
        graphPageViewController!.motionDataParser.settings = settings
        
        tempView = graphPageViewController!.view
        
        view.addSubview(tempView!)
        
        tempView!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempView!.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            tempView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tempView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tempView!.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
        
        setupGraphs()
		
	}
	
	private func setupMeasuringLabel() {
		measuringLabel.text = "Aan het meten..."
		view.addSubview(measuringLabel)
		
		view.addSubview(indicator)
		indicator.startAnimating()
		
		measuringLabel.translatesAutoresizingMaskIntoConstraints = false
		indicator.translatesAutoresizingMaskIntoConstraints = false
		
		view.addConstraints([
			measuringLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			measuringLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			indicator.centerYAnchor.constraint(equalTo: measuringLabel.centerYAnchor),
			indicator.leftAnchor.constraint(equalToSystemSpacingAfter: measuringLabel.rightAnchor, multiplier: 1.0)
		])
	}
	
	@objc private func tappedSaveButton() {
		var wrappedLat: NSNumber?
		var wrappedLong: NSNumber?
		
		if let lat = placemark?.location?.coordinate.latitude {
			wrappedLat = NSNumber(value: lat)
		}
		
		if let long = placemark?.location?.coordinate.longitude {
			wrappedLong = NSNumber(value: long)
		}
		
		let measurement = Measurement(dataPoints: dataPoints,
									  date: Date(),
									  latCoordinate: wrappedLat?.floatValue,
									  longCoordinate: wrappedLong?.floatValue,
									  locationString: placemark?.locality,
									  exceededLimit: exceededLimit,
									  persistableMeasurement: nil)
		
		print("created measurement")
		
        if let handler = completionHandler {
            handler(measurement)
        }
		
		presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
	}
    
    func setupToSaveDataToDatabase(completionHandler: @escaping (Measurement) -> Void){
        getLocation()
        self.completionHandler = completionHandler
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
		self.locationManager = locationManager
	}
}

extension MeasureViewController: CLLocationManagerDelegate {
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
