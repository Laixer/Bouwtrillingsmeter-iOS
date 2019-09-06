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
	
	private var showingGraphs = UserDefaults.standard.bool(forKey: "graphs")
	private var indicator = UIActivityIndicatorView(style: .gray)
	private var measuringLabel = UILabel()
	
	private let numberOfGraphs = 5
	private var completionHandler: ((Measurement) -> Void)?
	private var exceededLimit = false
	
	private var settings: MeasurementSettings?
	
	private let motionDataParser = MotionDataParser()
	
	private var updateHandler: MotionDataHandler?
    
    private var tempView: UIView?
    
    private var placemark: CLPlacemark?
    
    private let locationManager = CLLocationManager()
	
	init(settings: MeasurementSettings?) {
        
		self.settings = settings
		motionDataParser.settings = settings
		
		super.init(nibName: nil, bundle: nil)
		
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
    
    func setupGraphs() {
        
        let cover = UIView()
        cover.backgroundColor = UIColor.white
        cover.tag = 100

        graphPageViewController = GraphPageViewController()
        graphPageViewController!.motionDataParser.settings = settings
        graphPageViewController!.motionDataParser.graphPageView = graphPageViewController!
        
        tempView = graphPageViewController!.view
        
        view.addSubview(tempView!)
        view.addSubview(cover)
        
        tempView!.translatesAutoresizingMaskIntoConstraints = false
        cover.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tempView!.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            tempView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tempView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tempView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            cover.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1.0),
            cover.leftAnchor.constraint(equalTo: view.leftAnchor),
            cover.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cover.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        print(UserDefaults.standard.bool(forKey: "graphs"))
		
		view.backgroundColor = UIColor.white
        
        if showingGraphs {
            setupGraphs()
        }
        setupMeasuringLabel()
        
        // get newest location possible
        getLocation()
        
	}
	
	private func setupMeasuringLabel() {
        
        measuringLabel.text = "Aan het meten..."
        measuringLabel.tag = 101
        view.addSubview(measuringLabel)
		
        indicator.tag = 101
		view.addSubview(indicator)
		indicator.startAnimating()
        
        let showGraph = UIButton()
        showGraph.tag = 101
        showGraph.tintColor = .black
        showGraph.setTitleColor(UIColor.black, for: .normal)
        showGraph.layer.borderWidth = 1
        showGraph.setTitle("Toon grafieken", for: .normal)
        showGraph.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        if showingGraphs {
            view.addSubview(showGraph)
        }
        
        showGraph.addTarget(self, action: #selector(clickedShowGraphs), for: .touchUpInside)
        
		measuringLabel.translatesAutoresizingMaskIntoConstraints = false
		indicator.translatesAutoresizingMaskIntoConstraints = false
        showGraph.translatesAutoresizingMaskIntoConstraints = false
		
		view.addConstraints([
			measuringLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			measuringLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			indicator.centerYAnchor.constraint(equalTo: measuringLabel.centerYAnchor),
			indicator.leftAnchor.constraint(equalToSystemSpacingAfter: measuringLabel.rightAnchor, multiplier: 1.0),
            
		])
        
        if showingGraphs {
            view.addConstraints([
                showGraph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                showGraph.topAnchor.constraint(equalTo: measuringLabel.bottomAnchor, constant: 5),
                showGraph.heightAnchor.constraint(equalToConstant: 48.0),
                showGraph.widthAnchor.constraint(equalToConstant: 210.0),
            ])
        }
        
        
	}
    
    //swiftlint:disable identifier_name
    @objc private func clickedShowGraphs() {
        if let viewWithTag = self.view.viewWithTag(101) {
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    private func getLocation() {
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("ERROR: Can't retrieve location, reason: location services are disabled")
            return
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
	
	@objc private func tappedSaveButton() {
        
        DataHandler.stopMeasuring()
        MeasurementControl.onFinishMeasurement(placemark: placemark)

        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
	}
    
    func setupToSaveDataToDatabase(completionHandler: @escaping (Measurement) -> Void){
        self.completionHandler = completionHandler
    }
}

extension MeasureViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if placemark != nil {
            return
        }
        
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
