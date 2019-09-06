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
    private var addressLabel = UILabel()
	private var locationLabel = UILabel()
	private var timeLabel = UILabel()
	private var limitExceededLabel = UILabel()
	
	init(measurement: Measurement) {
		self.measurement = measurement
		
		titleLabel.text = measurement.name
        addressLabel.text = (measurement.address != nil) ? measurement.address! : "Onbekend"
		
		let dateFormatter = DateFormatter()
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "nl_NL")
		
		timeLabel.text = dateFormatter.string(from: measurement.dateEnd!)
        limitExceededLabel.text = measurement.exceededText

		super.init(nibName: nil, bundle: nil)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		limitExceededLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleLabel.leftAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leftAnchor, multiplier: 1.0),
			titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0),
            addressLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1.0),
            addressLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
			timeLabel.topAnchor.constraint(equalToSystemSpacingBelow: addressLabel.bottomAnchor, multiplier: 1.0),
			timeLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor),
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
        view.addSubview(addressLabel)
		view.addSubview(locationLabel)
		view.addSubview(timeLabel)
		view.addSubview(limitExceededLabel)
	}
}
