//
//  ViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 21/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let motionParser = MotionDataParser()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(_ animated: Bool) {
		motionParser.startDataCollection { (data, error) in
			if let data = data {
				print(String(format: "x: %.5f, y: %.5f, z: %.5f t:%.1f", abs(data.acceleration.x), abs(data.acceleration.y), abs(data.acceleration.z), data.timestamp))
				print(String(format: "x: %.2f, y: %.2f, z: %.2f", abs(data.rotationRate.x), abs(data.rotationRate.y), abs(data.rotationRate.z)))
			}
		}
	}


}

