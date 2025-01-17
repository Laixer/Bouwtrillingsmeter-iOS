//
//  MeasureViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 25/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import CoreLocation

class MeasureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var collectionView: UICollectionView
	
	var indicator = UIActivityIndicatorView(style: .gray)
	var measuringLabel = UILabel()
	
	let numberOfGraphs = 5
	var dataPoints = [DataPoint]()
	var completionHandler: ((Measurement) -> Void)?
	var locationManager: CLLocationManager?
	var placemark: CLPlacemark?
	
	var settings: MeasurementSettings?
	
	let motionDataParser = MotionDataParser()
	
	init(settings: MeasurementSettings?) {
		collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
		
		self.settings = settings
		motionDataParser.settings = settings
		
		super.init(nibName: nil, bundle: nil)
		
		motionDataParser.exceedanceCallback = { (frequency, ratio) in
			print("exceeded limit \(ratio) with dom freq: \(frequency)")
		}
	}
	
	override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.init(settings: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		
		navigationItem.title = "Meting"
		
		let saveButton = UIBarButtonItem(title: "Sla op", style: .done, target: self, action: #selector(tappedSaveButton))
		navigationItem.rightBarButtonItem = saveButton
		
		setupCollectionView()
		setupMeasuringLabel()
		collectionView.isHidden = true
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleGraphs))
		gestureRecognizer.numberOfTapsRequired = 7
		view.addGestureRecognizer(gestureRecognizer)
		
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
	
	func beginMeasurement(completionHandler: @escaping (Measurement) -> Void) {
		getLocation()
		
		self.completionHandler = completionHandler
		
		motionDataParser.settings = settings
		motionDataParser.startDataCollection(updateInterval: 0.02) { [weak weakSelf = self] (dataPoint, _) in
			for index in 0..<self.collectionView.numberOfItems(inSection: 0) {
				let indexPath = IndexPath(row: index, section: 0)
				if let dataPoint = dataPoint {
					weakSelf?.dataPoints.append(dataPoint)
					if let cell = self.collectionView.cellForItem(at: indexPath) as? GraphCollectionViewCell {
						self.updateCell(cell: cell, at: indexPath, with: dataPoint)
					}
				}
			}
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		motionDataParser.stopDataCollection()
	}
	
	private func updateCell(cell: GraphCollectionViewCell, at indexPath: IndexPath, with dataPoint: DataPoint) {
		switch indexPath.row {
		case 0:
			cell.addValues(values: [Double(dataPoint.speed.x) * 100, Double(dataPoint.speed.y) * 100, Double(dataPoint.speed.y) * 100])
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
			/*if (indexPath.row == 0) {
			cell.graphView.numberOfLines = 1
			} else if (indexPath.row == 4) {
			cell.graphView.numberOfLines = 6
			} else if (indexPath.row == 2) {
			cell.graphView.numberOfLines = 0
			} else {
			cell.graphView.numberOfLines = 3
			}*/
			if indexPath.row == 0 {
				cell.graphView.singleLine = true
			}
			
			return cell
		}
		
		fatalError("couldn't dequeue cell")
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let graphPageViewController = GraphPageViewController()
		graphPageViewController.initiallyVisibleGraphType = GraphType.allCases[indexPath.row]
		graphPageViewController.motionDataParser.settings = settings
		navigationController?.pushViewController(graphPageViewController, animated: true)
	}
	
	private func setupCollectionView() {
		collectionView.frame = view.bounds
		collectionView.dataSource = self
		collectionView.delegate = self
		view.addSubview(collectionView)
		
		collectionView.reloadData()
		collectionView.backgroundColor = UIColor.white
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.minimumInteritemSpacing = 22
			layout.minimumLineSpacing = 22
			layout.itemSize = CGSize(width: 120, height: 168)
			layout.sectionInset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
		}
		
		collectionView.register(GraphCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	@objc private func toggleGraphs() {
		collectionView.isHidden = !collectionView.isHidden
		indicator.isHidden = !indicator.isHidden
		measuringLabel.isHidden = !measuringLabel.isHidden
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
				
				print("locality: \(String(describing: placemarks?.first?.locality))")

			}
			print("location: \(location.coordinate)")
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
