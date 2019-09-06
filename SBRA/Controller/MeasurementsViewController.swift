//
//  MeasurementsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 16/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

class MeasurementsViewController: UIViewController {
	
	var rotterdamIconView: UIImageView
	var graphIconView: UIImageView
	let noMeasurementsLabel: UILabel
	let tableView: UITableView
	let backgroundColor = UIColor(white: 0.9, alpha: 1.0)
	
	var measurements = [Measurement]()
	
	let formatter = DateFormatter()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		rotterdamIconView = UIImageView(image: UIImage(named: "rotterdamicon"))
		graphIconView = UIImageView(image: UIImage(named: "graphicon"))
		noMeasurementsLabel = UILabel()
		noMeasurementsLabel.text = "U heeft nog geen metingen gedaan"
		noMeasurementsLabel.textColor = UIColor(white: 120.0/255.0, alpha: 1.0)
		
		tableView = UITableView()
		tableView.register(MeasurementTableViewCell.self, forCellReuseIdentifier: "bigcell")
		tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		tableView.delegate = self
		tableView.dataSource = self
		
		formatter.dateStyle = .long
		formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "nl_NL")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
															target: self,
															action: #selector(tappedAddButton))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Instellingen",
														   style: .plain,
														   target: self,
														   action: #selector(tappedSettingsButton))
		
		updateTableViewVisibility()
		
		view.backgroundColor = backgroundColor
		
		view.addSubview(rotterdamIconView)
		view.addSubview(graphIconView)
		view.addSubview(noMeasurementsLabel)
		view.addSubview(tableView)
		
		setupConstraints()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        measurements = Database().measurements
		
		updateTableViewVisibility()
		tableView.reloadData()
	}
	
	@objc private func tappedAddButton() {
		let measurementSettingsVC = MeasurementSettingsViewController()
		measurementSettingsVC.completionHandler = { [weak self] (measurement) in
			let detailViewController = MeasurementDetailViewController(measurement: measurement)
			self?.navigationController?.pushViewController(detailViewController, animated: false)
			
			self?.addMeasurement(measurement: measurement)
			print("number of measurements: \(Database().numberOfMeasurements())")
			self?.updateTableViewVisibility()
			self?.tableView.reloadData()
		}
		
		let navigationController = UINavigationController(rootViewController: measurementSettingsVC)
		
		// Reuse the app delegate's implementation of the navigation controller delegate for rotation
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			navigationController.delegate = appDelegate
		} else {
			fatalError("unknown app delegate")
		}
		
		present(navigationController, animated: true, completion: nil)
	}
	
	@objc private func tappedSettingsButton() {
		let appSettingsVC = AppSettingsViewController(style: .grouped)
		
		let navigationController = UINavigationController(rootViewController: appSettingsVC)
		
		// Reuse the app delegate's implementation of the navigation controller delegate for rotation
		if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
			navigationController.delegate = appDelegate
		} else {
			fatalError("unknown app delegate")
		}
		
		present(navigationController, animated: true, completion: nil)
	}
	
	private func addMeasurement(measurement: Measurement) {
		Database().addMeasurement(measurement: measurement)
		measurements = Database().measurements
	}
	
	private func setupConstraints() {
		let aboveRotterdamIconLayoutGuide = UILayoutGuide()
		view.addLayoutGuide(aboveRotterdamIconLayoutGuide)
		
		rotterdamIconView.translatesAutoresizingMaskIntoConstraints = false
		graphIconView.translatesAutoresizingMaskIntoConstraints = false
		noMeasurementsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			rotterdamIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			rotterdamIconView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16.0),
			
			aboveRotterdamIconLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
			aboveRotterdamIconLayoutGuide.bottomAnchor.constraint(equalTo: rotterdamIconView.topAnchor),
			
			graphIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			graphIconView.centerYAnchor.constraint(equalTo: aboveRotterdamIconLayoutGuide.centerYAnchor),
			
			noMeasurementsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			noMeasurementsLabel.topAnchor.constraint(equalToSystemSpacingBelow: graphIconView.bottomAnchor, multiplier: 1.0),
            
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
		])
	}
	
	private func updateTableViewVisibility() {
		// TODO: make this nicer
		if Database().numberOfMeasurements() == 0 {
			self.tableView.isHidden = true
			title = "Trillingsmeter"
		} else {
			title = "Metingen"
			tableView.isHidden = false
			tableView.frame = view.bounds
		}
	}
}

extension MeasurementsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Database().numberOfMeasurements()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "bigcell", for: indexPath) as? MeasurementTableViewCell
		let measurement = measurements[indexPath.row]
		cell?.nameLabel.text = measurement.name
		
		cell?.dateLabel.text = formatter.string(from: measurement.dateEnd!)
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}
}

extension MeasurementsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detail = MeasurementDetailViewController(measurement: measurements[indexPath.row])
		navigationController?.pushViewController(detail, animated: true)
	}
	
	func tableView(_ tableView: UITableView,
				   commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			Database().removeMeasurement(measurement: measurements[indexPath.row])
			measurements = Database().measurements
			
            tableView.deleteRows(at: [indexPath], with: .automatic)
			
			updateTableViewVisibility()
		}
	}
}
