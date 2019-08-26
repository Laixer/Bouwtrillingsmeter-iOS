//
//  CBarChart.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import Charts

class CBarChart: BarChartView {
    
    private let xDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "X")
    private let yDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Y")
    private let zDataSet = BarChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    init() {
        super.init(frame: .zero)
        
        xDataSet.setColor(xDataSetColor)
        yDataSet.setColor(yDataSetColor)
        zDataSet.setColor(zDataSetColor)
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
