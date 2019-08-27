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
    
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView?.translatesAutoresizingMaskIntoConstraints = false
		
        if let updateGraphHandler = updateGraphHandler {
            motionDataParser.startDataCollection(updateInterval: 0.02, handler: updateGraphHandler)
        }
		
		if let graphView = graphView {
			view.addSubview(graphView)
			
//            if !(graphView is DominantFrequencyGraphView) {
//                graphView.setNeedsDisplay()
//            }
		}
        
        getViewReady()
        
    }
    
    private func getViewReady(){
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
			
            self.graphView = CBarChart()
			
			var timer = 0
			var maxXSpeed = 0.0
			var maxYSpeed = 0.0
			var maxZSpeed = 0.0
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				timer += 1
				
				maxXSpeed = max(maxXSpeed, Double(abs(dataPoint?.speed.x ?? 0.0)))
				maxYSpeed = max(maxYSpeed, Double(abs(dataPoint?.speed.y ?? 0.0)))
				maxZSpeed = max(maxZSpeed, Double(abs(dataPoint?.speed.z ?? 0.0)))
				
				if timer == 100 {
					(self?.graphView as? CBarChart)!.addDataToSets(
                        xDataEntry: BarChartDataEntry(x: Double(self!.count), y: abs(Double(maxXSpeed * 1000))),
                        yDataEntry: BarChartDataEntry(x: Double(self!.count), y: abs(Double(maxYSpeed * 1000))),
                        zDataEntry: BarChartDataEntry(x: Double(self!.count), y: abs(Double(maxZSpeed * 1000)))
                    )
					
                    self!.count += 1
					
					(self?.graphView as? CBarChart)!.addDataToChart()
					
					timer = 0
					
					maxXSpeed = 0
					maxYSpeed = 0
					maxZSpeed = 0
				}
                
			}
			
		case .frequencyTime:
            
            self.graphView = CLineChart()
			
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
					if let dominantFrequency = dataPoint.dominantFrequency {
//                        print("dom x \(dominantFrequency.x.frequency) speed \(dominantFrequency.x.velocity)")
                        (self.graphView as? CLineChart)!.addDataToSets(
                            xDataEntry: ChartDataEntry(x: Double(self.count), y: Double(dominantFrequency.x.frequency)),
                            yDataEntry: ChartDataEntry(x: Double(self.count), y: Double(dominantFrequency.y.frequency)),
                            zDataEntry: ChartDataEntry(x: Double(self.count), y: Double(dominantFrequency.z.frequency))
                        )

                        (self.graphView as? CLineChart)!.addDataToChart()
                        
                        self.count += 1
					}
				}
			}

		case .dominantFrequency:
			graphView = DominantFrequencyGraphView(frame: .zero)
			
			if settings != nil {
				print("setting limit points")
			} else {
				print("settings or graphview is nil")
			}
			
			updateGraphHandler = { [weak self] (dataPoint: DataPoint?, error: Error?) in
				
				if let dominantFrequency = dataPoint?.dominantFrequency,
					let graphView = self?.graphView as? DominantFrequencyGraphView {
					
					if self!.count % 50 == 0 {
						graphView.addPointForDominantFrequencies(dominantFrequencies: [dominantFrequency])
					}
					
                    self?.count += 1
				}
			}
			
		case .fft1Second:
			self.graphView = CLineChart()
			
			(self.graphView as? CLineChart)!.setVisibleXRangeMaximum(500.0)
			
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let fftX = dataPoint?.fft.x, let fftY = dataPoint?.fft.y, let fftZ = dataPoint?.fft.z {
					
					for index in fftX.indices {
                        (self.graphView as? CLineChart)!.addDataToSets(
                            xDataEntry: ChartDataEntry(x: Double(index), y: Double(fftX[index] * 100.0)),
                            yDataEntry: ChartDataEntry(x: Double(index), y: Double(fftY[index] * 100.0)),
                            zDataEntry: ChartDataEntry(x: Double(index), y: Double(fftZ[index] * 100.0))
                        )
					}
					
					(self.graphView as? CLineChart)!.addDataToChart()
				}
			}
			
		case .gravityTimeAccelerationTime:
			
			self.graphView = CLineChart()
			
			updateGraphHandler = { (dataPoint: DataPoint?, error: Error?) in
				if let dataPoint = dataPoint {
                    (self.graphView as? CLineChart)!.addDataToSets(
                        xDataEntry: ChartDataEntry(x: Double(self.count), y: dataPoint.acceleration.x),
                        yDataEntry: ChartDataEntry(x: Double(self.count), y: dataPoint.acceleration.y),
                        zDataEntry: ChartDataEntry(x: Double(self.count), y: dataPoint.acceleration.z)
                    )
					
					self.count += 1
					
					(self.graphView as? CLineChart)!.setVisibleXRangeMaximum(100)
                    (self.graphView as? CLineChart)!.addDataToChart()
					(self.graphView as? CLineChart)!.moveViewToX(Double(self.count))
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
