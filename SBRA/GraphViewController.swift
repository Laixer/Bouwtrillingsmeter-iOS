//
//  GraphViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class GraphViewController: UIViewController {
	
	var graphType: GraphType
	var motionDataParser = MotionDataParser()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let graphView = GraphView(frame: view.bounds)
		
		motionDataParser.startDataCollection { (dataPoint, error) in
			if let acceleration = dataPoint?.acceleration {
				graphView.add([acceleration.x, acceleration.y, acceleration.z])
			}
		}
		
		view.addSubview(graphView)
		
		graphView.setNeedsDisplay()

        // Do any additional setup after loading the view.
    }
	
	init(graphType: GraphType) {
		self.graphType = graphType
		super.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init(nibName: bundle:) has not been implemented, use init(graphType:)")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
