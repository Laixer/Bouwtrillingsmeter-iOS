//
//  GraphViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 16/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class MeasurementsViewController: UIViewController {
	
	let motionParser = MotionDataParser()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Metingen"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton))
		
		view.backgroundColor = UIColor.white
		

    }
	
	@objc private func tappedAddButton() {
		let measurementSettingsVC = MeasurementSettingsViewController()
		let navigationController = UINavigationController(rootViewController: measurementSettingsVC)
		
		present(navigationController, animated: true, completion: nil)
	}
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
