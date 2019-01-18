//
//  MeasurementSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 13/01/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class MeasurementSettingsViewController: UIViewController {
	
	static let standardCellReuseIdentifier = "standardcell"
	static let switchCellReuseIdentifier = "switchCell"

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		title = "Nieuwe meting"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Begin",
															style: .plain,
															target: self,
															action: #selector(tappedBeginButton))
		
		
		setupTableView()

        // Do any additional setup after loading the view.
    }
	
	private func setupTableView() {
		let tableView = UITableView(frame: CGRect.zero)
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: MeasurementSettingsViewController.standardCellReuseIdentifier)
		tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: MeasurementSettingsViewController.switchCellReuseIdentifier)
		
		view.addSubview(tableView)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3.0).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1.0).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
		tableView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 1.0).isActive = true
		
		tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
		
		view.layoutIfNeeded()
		
		// Add an extra "separator" to the top of the table view
		let px = 1 / UIScreen.main.scale
		let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: px)
		let line = UIView(frame: frame)
		tableView.tableHeaderView = line
		line.backgroundColor = tableView.separatorColor
	}
	
	@objc private func tappedBeginButton() {
		let measureViewController = MeasureViewController()
		let navigationController = UINavigationController(rootViewController: measureViewController)
		
		present(navigationController, animated: true, completion: nil)
	}
	
	
	
}

extension MeasurementSettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath.row <= 1) {
			let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementSettingsViewController.standardCellReuseIdentifier)!
			
			
			cell.textLabel?.textColor = UIColor.rotterdamGreen
			if (indexPath.row == 0) {
				cell.textLabel?.text = "Kies categorie gebouw..."
			} else if (indexPath.row == 1) {
				cell.textLabel?.text = "Kies type trilling..."
			}
			
			
			return cell
		} else if (indexPath.row == 2) {
			let cell = tableView.dequeueReusableCell(withIdentifier: MeasurementSettingsViewController.switchCellReuseIdentifier)!
			
			cell.textLabel?.text = "Trillingsgevoelig gebouw"
			
			return cell
		}
		
		fatalError("Received nexpected index for table view cell")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		/*if (indexPath.row == 0) {
			let picker = UIPickerView(frame: CGRect.zero)
			//picker.delegate = self
		}*/
	}
}


