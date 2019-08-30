//
//  CScatterChart.swift
//  SBRA
//
//  Created by Anonymous on 29-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Charts

class CScatterChart: CombinedChartView, BaseChart {
    
    
    var xDataSet: ChartDataSet = ScatterChartDataSet(values: [ChartDataEntry](), label: "X")
    var yDataSet: ChartDataSet = ScatterChartDataSet(values: [ChartDataEntry](), label: "Y")
    var zDataSet: ChartDataSet = ScatterChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    var arrayOfDataSets: [ChartDataSet]?
    
    var xMultiplier: Double?
    var refreshing: Bool?
    
    var scrollingValue: Double?
    internal var cCount: Double = 0
    internal var hasScrolling: Bool = false
    
    init(xMultiplier: Double, refreshing: Bool) {
        super.init(frame: .zero)
        
        readyDataSets()
        
        arrayOfDataSets = [xDataSet, yDataSet, zDataSet]
        
        self.xMultiplier = xMultiplier
        self.refreshing = refreshing
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstantLine(entries: [ChartDataEntry], name: String, color: UIColor){
        let lineDataSet = LineChartDataSet(values: entries, label: name)
        
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawCircleHoleEnabled = false
        lineDataSet.lineWidth = 1
        lineDataSet.drawValuesEnabled = false
        
        lineDataSet.setColor(color)
        lineDataSet.highlightColor = color
        
        arrayOfDataSets!.append(lineDataSet)
        
        self.xAxis.axisMaximum = 100
        
    }
    
    func addDataToChart<T>(dataPoint: [DataPoint<T>]) {
        // do nothing
    }
    
    func addDataToChart(entries: [ChartDataEntry]){
        // loop through all dimensions, minus 1 so we exclude the constant line
        for index in 0..<arrayOfDataSets!.count - 1 {
            arrayOfDataSets![index].values.append(entries[index])
        }
        data = CombinedChartData(dataSets: arrayOfDataSets!)
    }
    
}
