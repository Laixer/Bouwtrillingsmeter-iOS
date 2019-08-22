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

        let graphPageViewController = GraphPageViewController()
        graphPageViewController.motionDataParser.settings = settings
        
        view.addSubview(graphPageViewController.view)
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
        
        setupGraphs()
		
//        setupCollectionView()
//        setupMeasuringLabel()
//        collectionView.isHidden = true
//
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleGraphs))
//        gestureRecognizer.numberOfTapsRequired = 7
//        view.addGestureRecognizer(gestureRecognizer)
		
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
	
	private func updateCell(cell: GraphCollectionViewCell, at indexPath: IndexPath, with dataPoint: DataPoint) {
		switch indexPath.row {
		case 0:
			cell.addValues(values: [Double(dataPoint.speed.x) * 100,
									Double(dataPoint.speed.y) * 100,
									Double(dataPoint.speed.y) * 100])
		case 1:
			if let dominantFrequency = dataPoint.dominantFrequency {
				cell.addValues(values: [Double(dominantFrequency.x.frequency) / 10.0,
										Double(dominantFrequency.y.frequency) / 10.0,
										Double(dominantFrequency.z.frequency) / 10.0])
			}
		case 3:
			cell.graphView.clear()
			if let fftX = dataPoint.fft.x, let fftY = dataPoint.fft.y, let fftZ = dataPoint.fft.z {
				for (index, element) in fftX.enumerated() {
					cell.addValues(values: [Double(element * 100.0), 0, 0])
				}
			}
		case 4:
			cell.addValues(values: [dataPoint.acceleration.x,
									dataPoint.acceleration.y,
									dataPoint.acceleration.z
				/*, gravity.x, gravity.y, gravity.z*/])
			
		default: break
			
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return numberOfGraphs
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GraphCollectionViewCell
		if let cell = cell {
			cell.backgroundColor = UIColor.rotterdamGreen
			cell.layer.cornerRadius = 8.0
			cell.text = GraphType.allCases[indexPath.row].description
			
			if indexPath.row == 0 {
				cell.graphView.singleLine = true
			}
			
			return cell
		}
		
		fatalError("couldn't dequeue cell")
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
