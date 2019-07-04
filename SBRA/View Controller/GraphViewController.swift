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
	
	var graphView: ChartViewBase!

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
		
		super.init(nibName: nil, bundle: nil)
		
		switch graphType {
		case .speedTime:
			
			self.graphView = BarChartView(frame: .zero)
			
			let xDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "X")
			let yDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Y")
			let zDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Z")
			
			xDataSet.setColor(UIColor.xDimensionColor)
			yDataSet.setColor(UIColor.yDimensionColor)
			zDataSet.setColor(UIColor.zDimensionColor)
			
			var timer = 0
			var count = 0
			var maxXSpeed = 0.0
			var maxYSpeed = 0.0
			var maxZSpeed = 0.0
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				timer += 1
				
				maxXSpeed = max(maxXSpeed, Double(dataPoint?.speed.x ?? 0.0))
				maxYSpeed = max(maxYSpeed, Double(dataPoint?.speed.y ?? 0.0))
				maxZSpeed = max(maxZSpeed, Double(dataPoint?.speed.z ?? 0.0))
				
				if timer == 100 {
					xDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxXSpeed * 1000))))
					yDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxYSpeed * 1000))))
					zDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxZSpeed * 1000))))
					
					count += 1
					
					let data = BarChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
					
					self?.graphView.data = data
					
					timer = 0
					
					maxXSpeed = 0
					maxYSpeed = 0
					maxZSpeed = 0
				}
			}
			
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
			*/
		case .gravityTimeAccelerationTime:
			
			let graphView = LineChartView(frame: .zero)
			
			self.graphView = graphView
			
			
			let xDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
			let yDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
			let zDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
			
			
			xDataSet.drawCirclesEnabled = false
			yDataSet.drawCirclesEnabled = false
			zDataSet.drawCirclesEnabled = false
			
			xDataSet.setColor(UIColor.xDimensionColor)
			yDataSet.setColor(UIColor.yDimensionColor)
			zDataSet.setColor(UIColor.zDimensionColor)
			
			var count = 0
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					xDataSet.append(BarChartDataEntry(x: Double(count), y: dataPoint.acceleration.x))
					yDataSet.append(BarChartDataEntry(x: Double(count), y: dataPoint.acceleration.y))
					zDataSet.append(BarChartDataEntry(x: Double(count), y: dataPoint.acceleration.z))
					
					count += 1
					
					let data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					//data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
					
					self?.graphView.data = data
				}
				
			}
			
		default: print("no graph provided")

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
