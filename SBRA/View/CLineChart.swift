//
//  Graph.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import Charts

class CLineChart: LineChartView {
    
    private let xDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
    private let yDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
    private let zDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    init() {
        super.init(frame: .zero)
        
        xDataSet.setColor(xDataSetColor)
        yDataSet.setColor(yDataSetColor)
        zDataSet.setColor(zDataSetColor)
        
        xDataSet.drawCirclesEnabled = false
        yDataSet.drawCirclesEnabled = false
        zDataSet.drawCirclesEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToChart() {
        data = LineChartData(dataSets: [xDataSet, yDataSet, zDataSet])
    }
    
    func addDataToSets(xDataEntry: ChartDataEntry, yDataEntry: ChartDataEntry, zDataEntry: ChartDataEntry){
        xDataSet.append(xDataEntry)
        yDataSet.append(yDataEntry)
        zDataSet.append(zDataEntry)
    }
    
}
