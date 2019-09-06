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
    
    private let cView = UIView()
    private let containerView = UIView()
	
	init(settings: MeasurementSettings?) {
        
		self.settings = settings
		motionDataParser.settings = settings
		
		super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Meting"
        
	}
	
	override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.init(settings: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func setupGraphs() {

        graphPageViewController = GraphPageViewController()
        graphPageViewController!.motionDataParser.settings = settings
        graphPageViewController!.motionDataParser.graphPageView = graphPageViewController!
        
        motionDataParser.startDataCollection(updateInterval: 0.01)
        
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
        
        setupDevice()
        
        // get newest location possible
        getLocation()
        
	}
    
    private func setupDevice() {
        
        containerView.backgroundColor = UIColor.white
        
        let setMobileReady = UILabel()
        setMobileReady.text = "Leg uw telefoon plat neer"
        
        view.addSubview(containerView)
        containerView.addSubview(setMobileReady)
        containerView.addSubview(indicator)
        indicator.startAnimating()
        
        let startMeasuring = UIButton()
        startMeasuring.tintColor = .black
        startMeasuring.setTitleColor(UIColor.black, for: .normal)
        startMeasuring.layer.borderWidth = 1
        startMeasuring.setTitle("Begin met meten", for: .normal)
        startMeasuring.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        containerView.addSubview(startMeasuring)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        setMobileReady.translatesAutoresizingMaskIntoConstraints = false
        startMeasuring.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            setMobileReady.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            setMobileReady.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            startMeasuring.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            startMeasuring.topAnchor.constraint(equalTo: setMobileReady.bottomAnchor, constant: 10),
            startMeasuring.heightAnchor.constraint(equalToConstant: 48.0),
            startMeasuring.widthAnchor.constraint(equalToConstant: 210.0),
            
            indicator.centerYAnchor.constraint(equalTo: setMobileReady.centerYAnchor),
            indicator.leftAnchor.constraint(equalToSystemSpacingAfter: setMobileReady.rightAnchor, multiplier: 1.0),
            
        ])
        
        startMeasuring.addTarget(self, action: #selector(startMeasurement), for: .touchUpInside)
        
    }
    
    @objc private func startMeasurement() {
        containerView.removeFromSuperview()
        if showingGraphs {
            setupGraphs()
        }
        setupMeasuringLabel()
        
        let saveButton = UIBarButtonItem(title: "Sla op", style: .done, target: self, action: #selector(tappedSaveButton))
        
        navigationItem.rightBarButtonItem = saveButton
    }
	
	private func setupMeasuringLabel() {
        
        view.addSubview(cView)
        cView.backgroundColor = UIColor.white
        
        measuringLabel.text = "Aan het meten..."
        cView.addSubview(measuringLabel)
		
		cView.addSubview(indicator)
		indicator.startAnimating()
        
        let showGraph = UIButton()
        showGraph.tintColor = .black
        showGraph.setTitleColor(UIColor.black, for: .normal)
        showGraph.layer.borderWidth = 1
        showGraph.setTitle("Toon grafieken", for: .normal)
        showGraph.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        if showingGraphs {
            cView.addSubview(showGraph)
        }
        
        showGraph.addTarget(self, action: #selector(clickedShowGraphs), for: .touchUpInside)
        
        cView.translatesAutoresizingMaskIntoConstraints = false
		measuringLabel.translatesAutoresizingMaskIntoConstraints = false
		indicator.translatesAutoresizingMaskIntoConstraints = false
        showGraph.translatesAutoresizingMaskIntoConstraints = false
		
		view.addConstraints([
            
            cView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cView.rightAnchor.constraint(equalTo: view.rightAnchor),
            cView.topAnchor.constraint(equalTo: view.topAnchor),
            cView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
			measuringLabel.centerXAnchor.constraint(equalTo: cView.centerXAnchor),
			measuringLabel.centerYAnchor.constraint(equalTo: cView.centerYAnchor),
			
			indicator.centerYAnchor.constraint(equalTo: measuringLabel.centerYAnchor),
			indicator.leftAnchor.constraint(equalToSystemSpacingAfter: measuringLabel.rightAnchor, multiplier: 1.0),
            
		])
        
        if showingGraphs {
            view.addConstraints([
                showGraph.centerXAnchor.constraint(equalTo: cView.centerXAnchor),
                showGraph.topAnchor.constraint(equalTo: measuringLabel.bottomAnchor, constant: 10),
                showGraph.heightAnchor.constraint(equalToConstant: 48.0),
                showGraph.widthAnchor.constraint(equalToConstant: 210.0),
            ])
        }
        
        
	}
    
    //swiftlint:disable identifier_name
    @objc private func clickedShowGraphs() {
        
        navigationController?.pushViewController(graphPageViewController!, animated: true)
        
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

        motionDataParser.stopDataCollection()
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
            let alertController = UIAlertController(title: "Locatievoorziening verplicht", message: "Geef alstublieft toestemming in de settings.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Annuleer", style: UIAlertAction.Style.cancel, handler: {(cAlertAcoin) in
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
