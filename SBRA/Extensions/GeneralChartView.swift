//
//  GeneralChartView.swift
//  SBRA
//
//  Created by Anonymous on 26-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation
import Charts

protocol BaseChart {
    var xDataSet: ChartDataSet {get set}
    var yDataSet: ChartDataSet {get set}
    var zDataSet: ChartDataSet {get set}
    
    var arrayOfDataSets: [ChartDataSet]? {get set}
    
    var xMultiplier: Double? {get set}
    
    var refreshing: Bool? {get set}
    
    var cCount:Double {get set}
    
    var hasScrolling: Bool {get set}
    
    var scrollingValue: Double? {get set}
}

extension BaseChart {
    func readyDataSets(){
        xDataSet.setColor(UIColor.xDimensionColor)
        yDataSet.setColor(UIColor.yDimensionColor)
        zDataSet.setColor(UIColor.zDimensionColor)
        
        xDataSet.drawValuesEnabled = false
        yDataSet.drawValuesEnabled = false
        zDataSet.drawValuesEnabled = false
    }
    func resetDatasets(){
        xDataSet.values.removeAll()
        yDataSet.values.removeAll()
        zDataSet.values.removeAll()
    }
    func scrollingMechanic(xAxis: XAxis) {
        xAxis.axisMaximum = (cCount == 0.0) ? scrollingValue! : cCount
        xAxis.axisMinimum = (cCount > scrollingValue!) ? cCount - scrollingValue! : 0.0
    }
    mutating func turnOnScrolling(newScrollingValue: Double) {
        hasScrolling = true
        scrollingValue = newScrollingValue
    }
}
