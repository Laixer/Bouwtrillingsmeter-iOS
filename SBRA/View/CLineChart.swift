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
    
    public let xDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
    public let yDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
    public let zDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
    
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
    
}
