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
	private var completionHandler: ((Measurement) -> Void)?
	private var exceededLimit = false
	
	private var settings: MeasurementSettings?
	
	private let motionDataParser = MotionDataParser()
	
	private var updateHandler: MotionDataHandler?
    
    private var tempView: UIView?
	
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

        graphPageViewController = GraphPageViewController()
        graphPageViewController!.motionDataParser.settings = settings
        graphPageViewController!.motionDataParser.graphPageView = graphPageViewController!
        
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
        
//        setupMeasuringLabel()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
//            self.view.subviews.forEach{$0.removeFromSuperview()}
//
//            self.setupGraphs()
//        })
        
        self.setupGraphs()
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
        
        DataHandler.stopMeasuring()
        MeasurementControl.onFinishMeasurement()
		
		presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
	}
    
    func setupToSaveDataToDatabase(completionHandler: @escaping (Measurement) -> Void){
        self.completionHandler = completionHandler
    }
}
