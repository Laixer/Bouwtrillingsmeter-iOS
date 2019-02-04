//
//  MeasurementSettingsViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 13/01/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class MeasurementSettingsViewController: UIViewController {
	
	private static let standardCellReuseIdentifier = "standardcell"
	private static let switchCellReuseIdentifier = "switchCell"
	
	private var selectedBuildingIndex: Int?
	private var selectedVibrationIndex: Int?
	
	private var selectedBuildingCategory: BuildingCategory? {
		get {
			if let index = selectedBuildingIndex {
				return BuildingCategory.allCases[index]
			}
			return nil
		}
	}
	private var selectedVibrationCategory: VibrationCategory? {
		get {
			if let index = selectedVibrationIndex {
				return VibrationCategory.allCases[index]
			}
			return nil
		}
	}
	
	private var pickerContainerView: UIView?
	private var pickerView: UIPickerView?
	private var tableView = UITableView(frame: .zero)
	
	private var selectedTableIndex: Int?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.white
		title = "Nieuwe meting"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Begin",
															style: .plain,
															target: self,
															action: #selector(tappedBeginButton))
		
		
		setupTableView()
		setupWizardButton()
		
		// Do any additional setup after loading the view.
	}
	
	private func setupTableView() {
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: MeasurementSettingsViewController.standardCellReuseIdentifier)
		tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: MeasurementSettingsViewController.switchCellReuseIdentifier)
		
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3.0),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1.0),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
			tableView.heightAnchor.constraint(equalToConstant: 133)
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
	
	private func setupWizardButton() {
		let button = UIButton(type: .system)
		button.setTitle("Ik weet het niet", for: .normal)
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		view.addSubview(button)
		
		button.addTarget(self, action: #selector(tappedWizardButton), for: .touchUpInside)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1.0),
			button.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
			
			]
		)
	}
	
	@objc private func tappedWizardButton() {
		let wizardVC = CategoryWizardViewController()
		navigationController?.pushViewController(wizardVC, animated: true)
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
				if let category = selectedVibrationCategory {
					cell.textLabel?.text = category.rawValue
				} else {
					cell.textLabel?.text = "Kies type trilling..."
				}
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
		showPickerView()
		
		selectedTableIndex = indexPath.row
		
		if ((0...1).contains(indexPath.row)) {
			if (selectedTableIndex == 0) {
				if let index = selectedBuildingIndex {
					pickerView?.selectRow(index, inComponent: 0, animated: false)
				} else {
					selectedBuildingIndex = 0
					tableView.reloadData()
					tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
				}
			} else if (selectedTableIndex == 1) {
				if let index = selectedVibrationIndex {
					pickerView?.selectRow(index, inComponent: 0, animated: false)
				} else {
					selectedVibrationIndex = 0
					tableView.reloadData()
					tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
				}
			}
			
			pickerView?.reloadAllComponents()
		}
	}
	
	func showPickerView() {
		if (pickerContainerView == nil) {
			let containerView = UIView(frame: .zero)
			view.addSubview(containerView)
			
			let picker = UIPickerView(frame: CGRect.zero)
			picker.delegate = self
			containerView.addSubview(picker)
			
			let buttonView = UIView(frame: .zero)
			containerView.addSubview(buttonView)
			
			let button = UIButton(frame: .zero)
			if let titleLabel = button.titleLabel {
				titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
			}
			button.setTitle("Gereed", for: .normal)
			button.setTitleColor(.rotterdamGreen, for: .normal)
			button.isUserInteractionEnabled = true
			button.addTarget(self, action: #selector(dismissPickerView), for: .touchUpInside)
			button.adjustsImageWhenHighlighted = true
			
			buttonView.addSubview(button)
			
			// Add a separator above the picker container view
			let px = 1 / UIScreen.main.scale
			let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: px)
			let topLine = UIView(frame: frame)
			topLine.backgroundColor = tableView.separatorColor
			
			containerView.addSubview(topLine)
			
			containerView.translatesAutoresizingMaskIntoConstraints = false
			buttonView.translatesAutoresizingMaskIntoConstraints = false
			picker.translatesAutoresizingMaskIntoConstraints = false
			button.translatesAutoresizingMaskIntoConstraints = false
			topLine.translatesAutoresizingMaskIntoConstraints = false
			
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
				
				button.rightAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.rightAnchor),
				button.topAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.topAnchor),
				button.bottomAnchor.constraint(equalTo: buttonView.layoutMarginsGuide.bottomAnchor),
				
				topLine.leftAnchor.constraint(equalTo: buttonView.leftAnchor),
				topLine.rightAnchor.constraint(equalTo: buttonView.rightAnchor),
				topLine.bottomAnchor.constraint(equalTo: buttonView.topAnchor),
				topLine.heightAnchor.constraint(equalToConstant: px)
				
				])
			
			pickerContainerView = containerView
			pickerView = picker
			
		}
	}
	
	@objc func dismissPickerView() {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedIndexPath, animated: true)
		}
		
		pickerContainerView?.removeFromSuperview()
		pickerView?.removeFromSuperview()
		pickerView = nil
		pickerContainerView = nil
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
		let indexPaths: [IndexPath]
		if (selectedTableIndex == 0) {
			indexPaths = [IndexPath(row: 0, section: 0)]
			selectedBuildingIndex = row
		} else {
			indexPaths = [IndexPath(row: 1, section: 0)]
			selectedVibrationIndex = row
		}
		
		tableView.reloadRows(at: indexPaths, with: .none)
		tableView.selectRow(at: indexPaths[0], animated: false, scrollPosition: .none)
	}
	
	
}


