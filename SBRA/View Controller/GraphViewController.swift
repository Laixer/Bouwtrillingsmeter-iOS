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
	var updateGraphHandler: MotionDataHandler?
	
	var graphView = GraphView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
		
		graphView.frame = view.bounds
		graphView.monochromeLines = false
		
		if let updateGraphHandler = updateGraphHandler {
			motionDataParser.startDataCollection(updateInterval: 0.01, handler: updateGraphHandler)
		}
		
		view.addSubview(graphView)
		
		graphView.setNeedsDisplay()

        // Do any additional setup after loading the view.
    }
	
	init(graphType: GraphType) {
		self.graphType = graphType
		
		super.init(nibName: nil, bundle: nil)
		
		switch graphType {
		case .speedTime:
			updateGraphHandler = { [unowned self] (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					self.graphView.add([Double(dataPoint.speed), 0, 0])
				}
			}
		case .frequencyTime:
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					if let dominantFrequency = dataPoint.dominantFrequency {
						self.graphView.add([Double(dominantFrequency.x.frequency) / 100.0,
												Double(dominantFrequency.y.frequency) / 100.0,
												Double(dominantFrequency.z.frequency) / 100.0])
					}
				}
			}
		case .speedFrequency:
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				
			}
			
		case .fft1Second:
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				self.graphView.clear()
				if let fft = dataPoint?.fft {
					for element in fft {
						self.graphView.add([Double(element * 100.0), 0, 0])
					}
				}
			}
		case .gravityTimeAccelerationTime:
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					self.graphView.add([dataPoint.acceleration.x,
										dataPoint.acceleration.y,
										dataPoint.acceleration.z
						/*, gravity.x, gravity.y, gravity.z*/])
				}
				
			}
		}
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
