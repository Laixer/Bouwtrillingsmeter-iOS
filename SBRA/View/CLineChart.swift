//
//  Graph.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

// swiftlint:disable force_cast

import Foundation
import Charts

class CLineChart: LineChartView, BaseChart {
    
    var xDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "X")
    var yDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Y")
    var zDataSet: ChartDataSet = LineChartDataSet(values: [ChartDataEntry](), label: "Z")
    
    var arrayOfDataSets: [ChartDataSet]?
    
    var xMultiplier: Double?
    
    var refreshing: Bool?
    
    internal var hasScrolling: Bool = false
    private var windowSize: Int?
    
    internal var cCount: Double = 0
    
    var scrollingValue: Double?
    
    init(xMultiplier: Double, refreshing: Bool) {
        super.init(frame: .zero)
        
        readyDataSets()
        
        (xDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
        (yDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
        (zDataSet as? LineChartDataSet)!.drawCirclesEnabled = false
        
        arrayOfDataSets = [xDataSet, yDataSet, zDataSet]
        
        self.xMultiplier = xMultiplier
        self.refreshing = refreshing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDataToChart<T>(dataPoint: [DataPoint<T>]) {
        if refreshing! {
            resetDatasets()
        }
        for dataPoint in dataPoint {
            for count in 0..<arrayOfDataSets!.count {
                let dataEntry = ChartDataEntry(x: cCount, y: Double(dataPoint.values[count]))
                arrayOfDataSets![count].values.append(dataEntry)
            }
            cCount += 1.0
        }
        
        data = LineChartData(dataSets: arrayOfDataSets!)
        if hasScrolling {
            self.scrollingMechanic(xAxis: self.xAxis)
        }
    }
    
}
