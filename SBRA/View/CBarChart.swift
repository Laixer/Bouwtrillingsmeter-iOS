//
//  CBarChart.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Charts

class CBarChart: BarChartView, BaseChart {

    var xDataSet: ChartDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "X")
    var yDataSet: ChartDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Y")
    var zDataSet: ChartDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    init() {
        super.init(frame: .zero)
        
        readyDataSets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToChart() {
        let data = BarChartData(dataSets: [xDataSet, yDataSet, zDataSet])
        data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
        self.data = data
    }
    
}
