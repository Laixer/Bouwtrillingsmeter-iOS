//
//  GraphViewController.swift
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
	
	var numberOfCells = 3
	
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
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
															target: self,
															action: #selector(tappedAddButton))
		
		updateTableViewVisibility()
		
		view.backgroundColor = UIColor.white
		
		view.addSubview(rotterdamIconView)
		view.addSubview(graphIconView)
		view.addSubview(noMeasurementsLabel)
		view.addSubview(tableView)
		
		setupConstraints()
    }
	
	@objc private func tappedAddButton() {
		let measurementSettingsVC = MeasurementSettingsViewController()
		let navigationController = UINavigationController(rootViewController: measurementSettingsVC)
		
		present(navigationController, animated: true, completion: nil)
	}
	
	private func setupConstraints() {
		let aboveRotterdamIconLayoutGuide = UILayoutGuide()
		view.addLayoutGuide(aboveRotterdamIconLayoutGuide)
		
		rotterdamIconView.translatesAutoresizingMaskIntoConstraints = false
		graphIconView.translatesAutoresizingMaskIntoConstraints = false
		noMeasurementsLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			rotterdamIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			rotterdamIconView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16.0),
			
			aboveRotterdamIconLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
			aboveRotterdamIconLayoutGuide.bottomAnchor.constraint(equalTo: rotterdamIconView.topAnchor),
			
			graphIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			graphIconView.centerYAnchor.constraint(equalTo: aboveRotterdamIconLayoutGuide.centerYAnchor),
			
			noMeasurementsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			noMeasurementsLabel.topAnchor.constraint(equalToSystemSpacingBelow: graphIconView.bottomAnchor, multiplier: 1.0)
		])
	}
	
	private func updateTableViewVisibility() {
		// TODO: make this nicer
		if tableView.numberOfSections == 0 {
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
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return numberOfCells
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "bigcell", for: indexPath)
		cell.layer.shadowPath = CGPath(rect: cell.bounds, transform: nil)
		cell.layer.shadowColor = UIColor.red.cgColor
		cell.clipsToBounds = false
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0.0
		}
		return 16.0
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		return view
	}
}

extension MeasurementsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView,
				   commit editingStyle: UITableViewCell.EditingStyle,
				   forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			numberOfCells -= 1
			let indexSet = IndexSet(integer: indexPath.section)
			
			tableView.deleteSections(indexSet, with: .fade)
			
			updateTableViewVisibility()
		}
	}
}
