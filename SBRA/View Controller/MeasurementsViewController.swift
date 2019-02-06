//
//  GraphViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 16/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

class MeasurementsViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Metingen"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
															target: self,
															action: #selector(tappedAddButton))
		
		view.backgroundColor = UIColor.white
    }
	
	@objc private func tappedAddButton() {
		let measurementSettingsVC = MeasurementSettingsViewController()
		let navigationController = UINavigationController(rootViewController: measurementSettingsVC)
		
		present(navigationController, animated: true, completion: nil)
	}
}
