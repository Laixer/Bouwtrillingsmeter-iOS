//
//  Chart.swift
//  SBRA
//
//  Created by Anonymous on 02-09-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation
import UIKit

class Chart {
    
    // establish all values for the chart
    private var needScrolling = false
    private var needRefresh = false
    
    private var chartView: AAChartView
    private var chartType: AAChartType
    private var chartModel: AAChartModel
    private var aaOptions: AAOptions
    
    // arrays to store values to be put in chart of different dimensions
    private var xArray: [[Double]] = []
    private var yArray: [[Double]] = []
    private var zArray: [[Double]] = []
    
    private var series: [AASeriesElement] = []
    
    private var xMultiplier: Double
    
    private var timeInMillis: Int?
    private var lastKnowCount = 0
    private var starDate: Int64?
    private var firstTime = true
    
    // initializer for the chart
    init(chartType: AAChartType, needScrolling: Bool, needRefresh: Bool, xMultiplier: Double) {
        
        self.chartView = AAChartView()
        
        self.chartType = chartType
        self.needScrolling = needScrolling
        self.needRefresh = needRefresh
        
        self.xMultiplier = xMultiplier
        
        // append all array data holders in the series array to use later in the chart model
        let xElement = AASeriesElement()
            .name("x")
            .data(xArray)
        let yElement = AASeriesElement()
            .name("y")
            .data(yArray)
        let zElement = AASeriesElement()
            .name("z")
            .data(zArray)
        
        if chartType == .line {
            xElement.lineWidth(1)
            yElement.lineWidth(1)
            zElement.lineWidth(1)
        }
        
        series.append(xElement)
        series.append(yElement)
        series.append(zElement)
        
        chartModel = AAChartModel()
            .title("")
            .chartType(chartType)//Can be any of the chart types listed under `AAChartType`.
            .dataLabelsEnabled(false)
            .colorsTheme([Const.GRAPH_X_COLOR, Const.GRAPH_Y_COLOR, Const.GRAPH_Z_COLOR])
            .tooltipEnabled(false)
            .tooltipCrosshairs(false)
            .markerRadius(0)
            .touchEventEnabled(false)
            .series(series)
        
        if chartType == .scatter {
            chartModel.symbol(.circle)
            chartModel.markerRadius(2)
        }
        
        aaOptions = AAOptionsComposer.configureAAOptions(aaChartModel: chartModel)
        
        if chartType == .column {
            aaOptions.plotOptions?.column?
                .groupPadding(0.01)
                .pointPadding(0.01)
                .grouping(true)
        }
        
    }
    
    func setMaxAndMinXAxis(min: Float, max: Float) {
        aaOptions.xAxis?.min(min)
        aaOptions.xAxis?.max(max)
    }
    
    // how long in seconds to scroll
    func scrollAtSeconds(timeInSeconds: Int){
        self.timeInMillis = timeInSeconds * 1000
    }
    
    // returns the whole chart
    func getChartView() -> AAChartView {
        return chartView
    }
    
    // draw chart
    func drawChart() {
        chartView.aa_drawChartWithChartOptions(aaOptions)
    }
    
    // logic to append data to chart
    func appendData<T>(data: [DataPoint<T>]) {
        
        if self.starDate == nil {
            self.starDate = Date().getCurrentMillis()
        }
        
        if needRefresh {
            emptyDataOfArrays()
        }
        
        lastKnowCount = data.count
        
        for dataPoint in data {
            self.xArray.append([dataPoint.xAXisValueAsDouble() * xMultiplier, Double(dataPoint.values[0])])
            self.yArray.append([dataPoint.xAXisValueAsDouble() * xMultiplier, Double(dataPoint.values[1])])
            self.zArray.append([dataPoint.xAXisValueAsDouble() * xMultiplier, Double(dataPoint.values[2])])
        }
        
        updateView()
    }
    
    func appendData(data: [[Double]]) {
        
        if needRefresh {
            emptyDataOfArrays()
        }
        
        self.xArray.append(data[0])
        self.yArray.append(data[1])
        self.zArray.append(data[2])
        
        updateView()
    }
    
    func addConstantLine(entries: [[Double]], name: String) {
        
        let constantSerie = AASeriesElement().name(name).color(Const.GRAPH_CONSTANT_COLOR).data(entries).type(.line).marker(
            AAMarker()
                .radius(0)
        )
        chartModel.series!.append(constantSerie.toDic()!)
        aaOptions = AAOptionsComposer.configureAAOptions(aaChartModel: chartModel)
        
    }
    
    // scroll the view at given seconds, clearing data before viewport reset
    private func updateView() {
        // TODO
        if (needScrolling && Date().getCurrentMillis() - self.starDate! >= timeInMillis!) || firstTime {
            
            if firstTime {
                firstTime = false
            }
            
            // calculate the max range to delete to, last known count is to the last send datapoint size in append method
            let maxRange = lastKnowCount
            xArray.removeSubrange(0..<maxRange)
            yArray.removeSubrange(0..<maxRange)
            zArray.removeSubrange(0..<maxRange)

        }
        
        // update chart with new data
        updateChartData()
        
    }
    
    private func updateChartData() {
        chartView.aa_onlyRefreshTheChartDataWithChartModelSeries([AASeriesElement()
            .name("x")
            .data(xArray).toDic()!, AASeriesElement()
                .name("y")
                .data(yArray).toDic()!, AASeriesElement()
                    .name("z")
                    .data(zArray).toDic()!])
    }
    
    private func emptyDataOfArrays() {
        self.xArray.removeAll()
        self.yArray.removeAll()
        self.zArray.removeAll()
    }
    
}
