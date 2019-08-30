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

class GraphViewController: UIViewController, DataIntervalClosedListener {
    
    var titleLabel = UILabel()
    var xTitleLabel = UILabel()
    var yTitleLabel = UILabel()
	
	var graphType: GraphType
	
	var graphView: ChartViewBase?
    
    let MULTIPLIER: Double = 0.001

    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView?.translatesAutoresizingMaskIntoConstraints = false
		
		if let graphView = graphView {
			view.addSubview(graphView)
		}
        
        getViewReady()
        
    }
    
    private func getViewReady() {
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
            graphView!.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    func onDataIntervalClosed(dataInterval: DataInterval?) {
        if dataInterval == nil {
            return
        }
        switch graphType {
        case .accelerationTime:
            (graphView! as? CLineChart)!.addDataToChart(dataPoint: dataInterval!.getAcceleration())
            return
        case .highestVelocityTime:
            (graphView! as? CBarChart)!.addDataToChart(dataPoint: dataInterval!.getVelocitiesAbsMaxAsDataPoints())
            return
        case .dominantFrequencyTime:
            (graphView! as? CBarChart)!.addDataToChart(dataPoint: dataInterval!.getDominantFrequenciesAsDataPoints())
            return
        case .amplitudeFrequency:
            (graphView! as? CLineChart)!.addDataToChart(dataPoint: dataInterval!.getFrequencyAmplitudes())
            return
        case .dominantFrequencyFrequency:
            (graphView! as? CScatterChart)!.addDataToChart(entries: dataInterval!.getAllDominantFrequenciesAsEntries())
            return
        }
    }
	
	// swiftlint:disable:next function_body_length
	init(graphType: GraphType, settings: MeasurementSettings?) {
		self.graphType = graphType
		
		super.init(nibName: nil, bundle: nil)
		
		switch graphType {
        case .accelerationTime:
            self.graphView = CLineChart(xMultiplier: MULTIPLIER, refreshing: false)
            if var graphView = graphView as? CLineChart {
                graphView.turnOnScrolling(newScrollingValue: 300)
            }
        case .highestVelocityTime:
            self.graphView = CBarChart(xMultiplier: MULTIPLIER, refreshing: false)
        case .dominantFrequencyTime:
            self.graphView = CBarChart(xMultiplier: MULTIPLIER, refreshing: false)
        case .amplitudeFrequency:
            self.graphView = CLineChart(xMultiplier: 1, refreshing: true)
            (self.graphView as? CLineChart)!.setVisibleXRangeMaximum(500.0)
        case .dominantFrequencyFrequency:
            self.graphView = CScatterChart(xMultiplier: 1, refreshing: false)
            (self.graphView as? CScatterChart)!.addConstantLine(entries: PowerLimit.getLimitAsEntries(settings: settings!), name: "Constant", color: .brown)
		}
        
        DataHandler.addDataIntervalClosedListener(listener: self)
    
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
