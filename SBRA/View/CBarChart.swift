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

    var xDataSet: ChartDataSet = BarChartDataSet(values: [BarChartDataEntry](), label: "X")
    var yDataSet: ChartDataSet = BarChartDataSet(values: [BarChartDataEntry](), label: "Y")
    var zDataSet: ChartDataSet = BarChartDataSet(values: [BarChartDataEntry](), label: "Z")
    
    var arrayOfDataSets: [ChartDataSet]?
    
    var xMultiplier: Double?
    var refreshing: Bool?
    
    internal var cCount: Double = 0
    
    internal var hasScrolling = false
    
    var scrollingValue: Double?
    
    init(xMultiplier: Double, refreshing: Bool) {
        super.init(frame: .zero)
        
        readyDataSets()
        
        arrayOfDataSets = [xDataSet, yDataSet, zDataSet]
        
        self.xMultiplier = xMultiplier
        self.refreshing = refreshing

        self.xAxis.axisMaximum = 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToChart<T>(dataPoint: [DataPoint<T>]) {
        if refreshing! {
            readyDataSets()
        }
        // using custom count for x axis because its not working otherwise
        for dataPoint in dataPoint {
            for count in 0..<arrayOfDataSets!.count {
                let dataEntry = BarChartDataEntry(x: cCount, y: Double(dataPoint.values[count]))
                arrayOfDataSets![count].values.append(dataEntry)
            }
            cCount += 1.0
        }
        let data = BarChartData(dataSets: arrayOfDataSets!)
        if data.dataSetCount > 1 {
            data.groupBars(fromX: 0, groupSpace: 0.1, barSpace: 0.01)
        }
        self.data = data
    }
    
}
