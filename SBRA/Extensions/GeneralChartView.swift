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
}

extension BaseChart {
    func readyDataSets(){
        xDataSet.setColor(UIColor.xDimensionColor)
        yDataSet.setColor(UIColor.yDimensionColor)
        zDataSet.setColor(UIColor.zDimensionColor)
    }
    func addDataToSets(xDataEntry: ChartDataEntry, yDataEntry: ChartDataEntry, zDataEntry: ChartDataEntry){
        xDataSet.append(xDataEntry)
        yDataSet.append(yDataEntry)
        zDataSet.append(zDataEntry)
    }
}
