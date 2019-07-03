//
//  MeasurementDetailViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 02/07/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class MeasurementDetailViewController: UIViewController {
	
	var measurement: Measurement
	
	private var titleLabel = UILabel()
	private var locationLabel = UILabel()
	private var timeLabel = UILabel()
	private var limitExceededLabel = UILabel()
	
	init(measurement: Measurement) {
		self.measurement = measurement
		
		titleLabel.text = measurement.locationString == nil
			? "Meting op onbekende locatie"
			: "Meting in \(measurement.locationString!)"
		
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .long
		
		timeLabel.text = dateFormatter.string(from: measurement.date)
		
		limitExceededLabel.text = measurement.exceededLimit ? "Overschrijdingen gedetecteerd" : "Geen overschrijdingen"
		
		super.init(nibName: nil, bundle: nil)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		limitExceededLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleLabel.leftAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leftAnchor, multiplier: 1.0),
			titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
			timeLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
			timeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
			limitExceededLabel.topAnchor.constraint(equalToSystemSpacingBelow: timeLabel.bottomAnchor, multiplier: 1.0),
			limitExceededLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor)
			
		])
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Meting"
		
		view.backgroundColor = .white
		
		view.addSubview(titleLabel)
		view.addSubview(locationLabel)
		view.addSubview(timeLabel)
		view.addSubview(limitExceededLabel)
	}
}
