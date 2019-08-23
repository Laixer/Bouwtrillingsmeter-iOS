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
    
    var titleLabel = UILabel()
    var xTitleLabel = UILabel()
    var yTitleLabel = UILabel()
	
	var graphType: GraphType
	var motionDataParser = MotionDataParser()
	var updateGraphHandler: MotionDataHandler?
	
	var graphView: ChartViewBase?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView?.frame = .zero
        graphView?.translatesAutoresizingMaskIntoConstraints = false
		
		if let updateGraphHandler = updateGraphHandler {
			motionDataParser.startDataCollection(updateInterval: 0.02, handler: updateGraphHandler)
		}
		
		if let graphView = graphView {
			view.addSubview(graphView)
			
			if !(graphView is DominantFrequencyGraphView) {
				graphView.setNeedsDisplay()
			}
		}
        
        titleLabel.text = graphType.description
        view.addSubview(titleLabel)
        
        xTitleLabel.text = graphType.xDescription
        view.addSubview(xTitleLabel)
        
        yTitleLabel.text = graphType.yDescription
        view.addSubview(yTitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        xTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        yTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // rotate yTitleLabel to put next to yaxis
        yTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        let yTitleLabelWidth = yTitleLabel.intrinsicContentSize.width / 2 - 10
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            
            xTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            xTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            yTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -yTitleLabelWidth),
            yTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            graphView!.bottomAnchor.constraint(equalTo: xTitleLabel.topAnchor),
            graphView!.leftAnchor.constraint(equalTo: yTitleLabel.rightAnchor, constant: -yTitleLabelWidth),
            graphView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        ])
        
    }
	
	override func viewDidDisappear(_ animated: Bool) {
		motionDataParser.stopDataCollection()
	}
	
	// swiftlint:disable:next function_body_length
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
				
				maxXSpeed = max(maxXSpeed, Double(abs(dataPoint?.speed.x ?? 0.0)))
				maxYSpeed = max(maxYSpeed, Double(abs(dataPoint?.speed.y ?? 0.0)))
				maxZSpeed = max(maxZSpeed, Double(abs(dataPoint?.speed.z ?? 0.0)))
				
				if timer == 100 {
					xDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxXSpeed * 1000))))
					yDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxYSpeed * 1000))))
					zDataSet.append(BarChartDataEntry(x: Double(count), y: abs(Double(maxZSpeed * 1000))))
					
					count += 1
					
					let data = BarChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
					
					self?.graphView?.data = data
					
					timer = 0
					
					maxXSpeed = 0
					maxYSpeed = 0
					maxZSpeed = 0
				}
                
			}
			
		case .frequencyTime:

            let xDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
            let yDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
            let zDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
			
			xDataSet.drawCirclesEnabled = false
			yDataSet.drawCirclesEnabled = false
			zDataSet.drawCirclesEnabled = false
			
			xDataSet.setColor(UIColor.xDimensionColor)
			yDataSet.setColor(UIColor.yDimensionColor)
			zDataSet.setColor(UIColor.zDimensionColor)

			let graphView = LineChartView(frame: .zero)
			self.graphView = graphView
			
			var count = 0
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					if let dominantFrequency = dataPoint.dominantFrequency {
						print("dom x \(dominantFrequency.x.frequency) speed \(dominantFrequency.x.velocity)")
						xDataSet.append(ChartDataEntry(x: Double(count), y: Double(dominantFrequency.x.frequency)))
						yDataSet.append(ChartDataEntry(x: Double(count), y: Double(dominantFrequency.y.frequency)))
						zDataSet.append(ChartDataEntry(x: Double(count), y: Double(dominantFrequency.z.frequency)))
						
						graphView.data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
						
						count += 1
					}
				}
			}

		case .dominantFrequency:
			graphView = DominantFrequencyGraphView(frame: .zero)
			
			var counter = 0
			
			if settings != nil {
				print("setting limit points")
			} else {
				print("settings or graphview is nil")
			}
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				
				if let dominantFrequency = dataPoint?.dominantFrequency,
					let graphView = self?.graphView as? DominantFrequencyGraphView {
					
					if counter % 50 == 0 {
						graphView.addPointForDominantFrequencies(dominantFrequencies: [dominantFrequency])
					}
					
					counter += 1
				}
			}
			
		case .fft1Second:
			let graphView = LineChartView(frame: .zero)
			
			self.graphView = graphView
			
			graphView.setVisibleXRangeMaximum(500.0)
			
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let fftX = dataPoint?.fft.x, let fftY = dataPoint?.fft.y, let fftZ = dataPoint?.fft.z {
                    let xDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
                    let yDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
                    let zDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
					
					xDataSet.drawCirclesEnabled = false
					yDataSet.drawCirclesEnabled = false
					zDataSet.drawCirclesEnabled = false
					
					xDataSet.setColor(UIColor.xDimensionColor)
					yDataSet.setColor(UIColor.yDimensionColor)
					zDataSet.setColor(UIColor.zDimensionColor)
					
					for index in fftX.indices {
						xDataSet.append(ChartDataEntry(x: Double(index), y: Double(fftX[index] * 100.0)))
						yDataSet.append(ChartDataEntry(x: Double(index), y: Double(fftY[index] * 100.0)))
						zDataSet.append(ChartDataEntry(x: Double(index), y: Double(fftZ[index] * 100.0)))
					}
					
					let data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					
					graphView.data = data
				}
			}
			
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
			
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					xDataSet.append(ChartDataEntry(x: Double(count), y: dataPoint.acceleration.x))
					yDataSet.append(ChartDataEntry(x: Double(count), y: dataPoint.acceleration.y))
					zDataSet.append(ChartDataEntry(x: Double(count), y: dataPoint.acceleration.z))
					
					count += 1
					
					let data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
					
					graphView.setVisibleXRangeMaximum(100)
					graphView.data = data
					graphView.moveViewToX(Double(count))
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
