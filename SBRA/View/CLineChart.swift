//
//  Graph.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Charts

class CLineChart: LineChartView, BaseChart {
    
    var xDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
    var yDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
    var zDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    init() {
        super.init(frame: .zero)
        
        readyDataSets()
        
        (xDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
        (yDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
        (zDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToChart() {
        data = LineChartData(dataSets: [(xDataSet as? LineChartDataSet)!, (yDataSet as? LineChartDataSet)!, (zDataSet as? LineChartDataSet)!])
    }
    
}
