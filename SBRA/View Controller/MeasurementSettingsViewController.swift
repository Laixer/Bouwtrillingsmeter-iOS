//
//  MeasurementSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 13/01/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

enum BuildingCategory: String, CaseIterable {
	case a = "A"
	case b = "B"
	case c = "C"
}

enum VibrationCategory: String, CaseIterable {
	case d = "D"
	case e = "E"
	case f = "F"
}

class MeasurementSettingsViewController: UIViewController {
	
	static let standardCellReuseIdentifier = "standardcell"
	static let switchCellReuseIdentifier = "switchCell"
	
	var selectedBuildingCategory: BuildingCategory?
	
	var pickerContainerView: UIView?
	var pickerView: UIPickerView?
	
	var selectedTableIndex: Int?
	
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
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3.0),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1.0),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
			tableView.heightAnchor.constraint(equalToConstant: 200)
			])
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
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
				if let category = selectedBuildingCategory {
					cell.textLabel?.text = category.rawValue
				} else {
					cell.textLabel?.text = "Kies categorie gebouw..."
				}
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
		if (pickerContainerView == nil) {
			let containerView = UIView(frame: .zero)
			view.addSubview(containerView)
			
			let picker = UIPickerView(frame: CGRect.zero)
			//picker.backgroundColor = .blue
			picker.delegate = self
			containerView.addSubview(picker)
			
			let buttonView = UIView(frame: .zero)
			//buttonView.backgroundColor = .red
			//buttonView.alpha = 0.5
			containerView.addSubview(buttonView)
			
			let button = UIButton(frame: .zero)
			if let titleLabel = button.titleLabel {
				titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
			}
			button.setTitle("Gereed", for: .normal)
			//button.backgroundColor = UIColor.blue
			button.setTitleColor(.rotterdamGreen, for: .normal)
			
			
			buttonView.addSubview(button)
			
			
			containerView.translatesAutoresizingMaskIntoConstraints = false
			buttonView.translatesAutoresizingMaskIntoConstraints = false
			picker.translatesAutoresizingMaskIntoConstraints = false
			button.translatesAutoresizingMaskIntoConstraints = false
			
			NSLayoutConstraint.activate([
				containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
				containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
				containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				containerView.heightAnchor.constraint(equalToConstant: 300),
				
				picker.leftAnchor.constraint(equalTo: containerView.leftAnchor),
				picker.rightAnchor.constraint(equalTo: containerView.rightAnchor),
				picker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
				
				buttonView.topAnchor.constraint(equalTo: picker.topAnchor),
				buttonView.leftAnchor.constraint(equalTo: picker.leftAnchor),
				buttonView.rightAnchor.constraint(equalTo: picker.rightAnchor),
				//buttonView.heightAnchor.constraint(equalToConstant: 44.0),
				
				button.rightAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.rightAnchor),
				button.topAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.topAnchor),
				button.bottomAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.bottomAnchor)
				
				])
			
			pickerContainerView = containerView
			pickerView = picker
		}
		
		selectedTableIndex = indexPath.row
		if ((0...1).contains(indexPath.row)) {
			pickerView?.reloadAllComponents()
		}
		
	}
}

extension MeasurementSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 3
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if (selectedTableIndex == 0) {
			return BuildingCategory.allCases[row].rawValue
		} else if (selectedTableIndex == 1) {
			return VibrationCategory.allCases[row].rawValue
		}
		
		return nil
	}
	
	func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return view.frame.width
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedBuildingCategory = BuildingCategory.allCases[row]
		//tablevie
	}
	
	
}


