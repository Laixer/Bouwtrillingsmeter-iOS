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
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
		
		view.backgroundColor = UIColor.white
		let graphView = GraphView()
		view.addSubview(graphView)
		graphView.bounds.size = CGSize(width: view.bounds.width, height: 300)
		graphView.center = view.center
		
		motionParser.startDataCollection { (data, error) in
			if let data = data {
				graphView.add(double3(data.acceleration.x, data.acceleration.y, data.acceleration.z))
			}
		}

    }
	
	@objc private func addTapped() {
		let measureViewController = MeasureViewController()
		let navigationController = UINavigationController(rootViewController: measureViewController)
		
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
