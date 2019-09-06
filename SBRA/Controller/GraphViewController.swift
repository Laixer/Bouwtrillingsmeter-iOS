//
//  GraphViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable switch_case_alignment

import UIKit
import simd

class GraphViewController: UIViewController, DataIntervalClosedListener {
    
    var xTitleLabel = UILabel()
    var yTitleLabel = UILabel()
	
	var graphType: GraphType
    
    var chart: Chart?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        chart!.drawChart()
        
        chart!.getChartView().translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(chart!.getChartView())
        
        self.view.isUserInteractionEnabled = false
        
        getViewReady()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.title = graphType.description
    }
    
    private func getViewReady() {
        
        xTitleLabel.text = graphType.xDescription
        view.addSubview(xTitleLabel)
        
        yTitleLabel.text = graphType.yDescription
        view.addSubview(yTitleLabel)
        
        xTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        yTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // rotate yTitleLabel to put next to yaxis
        yTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        let yTitleLabelWidth = yTitleLabel.intrinsicContentSize.width / 2 - 10
        
        NSLayoutConstraint.activate([
            
            xTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            xTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            yTitleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: -yTitleLabelWidth),
            yTitleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            chart!.getChartView().bottomAnchor.constraint(equalTo: xTitleLabel.topAnchor),
            chart!.getChartView().leftAnchor.constraint(equalTo: yTitleLabel.rightAnchor, constant: -yTitleLabelWidth),
            chart!.getChartView().rightAnchor.constraint(equalTo: view.rightAnchor),
            chart!.getChartView().topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func onDataIntervalClosed(dataInterval: DataInterval?) {
        if dataInterval == nil {
            return
        }
        switch graphType {
        case .accelerationTime:
            chart!.appendData(data: dataInterval!.getAcceleration())
            return
        case .highestVelocityTime:
            chart!.appendData(data: dataInterval!.getVelocitiesAbsMaxAsDataPoints())
            return
        case .dominantFrequencyTime:
            chart!.appendData(data: dataInterval!.getDominantFrequenciesAsDataPoints())
            return
        case .amplitudeFrequency:
            chart!.appendData(data: dataInterval!.getFrequencyAmplitudes())
            return
        case .dominantFrequencyFrequency:
            chart!.appendData(data: dataInterval!.getAllDominantFrequenciesAsEntries())
            return
        }
    }
	
	// swiftlint:disable:next function_body_length
	init(graphType: GraphType, settings: MeasurementSettings?) {
		self.graphType = graphType
		
		super.init(nibName: nil, bundle: nil)
		
		switch graphType {
        case .accelerationTime:
            chart = Chart(chartType: .line, needScrolling: true, needRefresh: false, xMultiplier: 0.001)
            chart?.scrollAtSeconds(timeInSeconds: 3)
        case .highestVelocityTime:
            chart = Chart(chartType: .column, needScrolling: true, needRefresh: false, xMultiplier: 0.001)
            chart?.scrollAtSeconds(timeInSeconds: 300)
        case .dominantFrequencyTime:
            chart = Chart(chartType: .column, needScrolling: true, needRefresh: false, xMultiplier: 0.001)
            chart?.scrollAtSeconds(timeInSeconds: 300)
        case .amplitudeFrequency:
            chart = Chart(chartType: .line, needScrolling: false, needRefresh: true, xMultiplier: 1)
            chart!.setMaxAndMinXAxis(min: 0, max: 50)
        case .dominantFrequencyFrequency:
            chart = Chart(chartType: .scatter, needScrolling: false, needRefresh: false, xMultiplier: 1)
            chart!.addConstantLine(entries: PowerLimit.getLimitAsEntries(settings: settings!), name: "constant")
            chart!.setMaxAndMinXAxis(min: 0, max: 50)
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
