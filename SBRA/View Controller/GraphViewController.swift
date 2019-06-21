//
//  GraphViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd
import Charts

class GraphViewController: UIViewController {
	
	var graphType: GraphType
	var motionDataParser = MotionDataParser()
	var updateGraphHandler: MotionDataHandler?
	
	var graphView: BarChartView

    override func viewDidLoad() {
        super.viewDidLoad()
		
		graphView.frame = view.bounds
		
		if let updateGraphHandler = updateGraphHandler {
			motionDataParser.startDataCollection(updateInterval: 0.01, handler: updateGraphHandler)
		}
		
		view.addSubview(graphView)
		
		graphView.setNeedsDisplay()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		motionDataParser.stopDataCollection()
	}
	
	init(graphType: GraphType, settings: MeasurementSettings?) {
		self.graphType = graphType
		motionDataParser.settings = settings
		
		self.graphView = BarChartView(frame: .zero)
		super.init(nibName: nil, bundle: nil)
		
		switch graphType {
		case .speedTime:
			let xDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "X")
			let yDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Y")
			let zDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Z")
			
			var timer = 0
			var count = 0
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				timer += 1
				if timer == 100 {
					if let dataPoint = dataPoint {
						print("adding (\(count), \(abs(Double(dataPoint.speed.x))))")
						xDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(dataPoint.speed.x * 1))))
						yDataSet.append(ChartDataEntry(x: Double(count), y: abs(Double(dataPoint.speed.y * 1))))
						zDataSet.append(ChartDataEntry(x: Double(count), y: abs(Double(dataPoint.speed.z * 1))))
						count += 1
					}
					
					let data = BarChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
					
					self?.graphView.data = data
					
					timer = 0
				}
				
				/*self?.graphView.leftAxis.axisMinimum = 0
				self?.graphView.leftAxis.axisMaximum = 0.01
				self?.graphView.xAxis.axisMinimum = 0
				self?.graphView.xAxis.axisMaximum = 100*/
				
				/*print("min x \(self?.graphView.chartXMin)")
				print("max x \(self?.graphView.chartXMax)")
				print("max y \(self?.graphView.chartYMax)")
				print("max y \(self?.graphView.chartYMax)")*/

				//self?.graphView.data = BarChartData(dataSets: [xDataSet, yDataSet, zDataSet])
			}
			
		default: print("no graph provided")
			
		/*
		case .frequencyTime:

			let xDataSet = LineChartDataSet([ChartDataEntry]())
			let yDataSet = LineChartDataSet([ChartDataEntry]())
			let zDataSet = LineChartDataSet([ChartDataEntry]())
			
			graphView.data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					if let dominantFrequency = dataPoint.dominantFrequency {
						self?.graphView.add([Double(dominantFrequency.x.frequency) / 10.0,
												Double(dominantFrequency.y.frequency) / 10.0,
												Double(dominantFrequency.z.frequency) / 10.0])
					}
				}
			}
		case .dominantFrequency:
			graphView = DominantFrequencyGraphView(frame: .zero)
			
			var counter = 0
			
			if let settings = settings, let graphView = self.graphView as? DominantFrequencyGraphView {
				graphView.limitPoints = PowerLimit.limitForSettings(settings: settings)
				print("setting limit points")
			} else {
				print("is nil")
			}
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				
				if let dominantFrequency = dataPoint?.dominantFrequency, let graphView = self?.graphView as? DominantFrequencyGraphView {
					if graphView.dominantFrequencies == nil {
						graphView.dominantFrequencies = [(DominantFrequency, DominantFrequency, DominantFrequency)]()
					}
					
					if counter % 50 == 0 {
						graphView.dominantFrequencies!.append(dominantFrequency)
						graphView.setNeedsDisplay()
					}
					
					counter += 1
				}
			}
			
		case .fft1Second:
			graphView = GraphView(frame: .zero)

			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				self?.graphView.clear()
				if let fftX = dataPoint?.fft.x, let fftY = dataPoint?.fft.y, let fftZ = dataPoint?.fft.z {
					for (index, element) in fftX.enumerated() {
						self?.graphView.add([Double(element * 100.0), Double(fftY[index] * 100.0), Double(fftZ[index] * 100.0)])
					}
				}
			}
		case .gravityTimeAccelerationTime:
			graphView = GraphView(frame: .zero)

			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					self?.graphView.add([dataPoint.acceleration.x,
										dataPoint.acceleration.y,
										dataPoint.acceleration.z
						/*, gravity.x, gravity.y, gravity.z*/])
				}
				
			}
			*/
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
