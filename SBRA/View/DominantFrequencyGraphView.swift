//
//  DominantFrequencyGraphView.swift
//  SBRA
//
//  Created by Wander Siemers on 03/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit
import Charts

class DominantFrequencyGraphView: BubbleChartView {
	
	var dominantFrequencies: [(DominantFrequency, DominantFrequency, DominantFrequency)]?
	
	private let xDataSet = BubbleChartDataSet(entries: [BubbleChartDataEntry](), label: "X")
	private let yDataSet = BubbleChartDataSet(entries: [BubbleChartDataEntry](), label: "Y")
	private let zDataSet = BubbleChartDataSet(entries: [BubbleChartDataEntry](), label: "Z")
	
	var yMax: CGFloat?
	var xMax: CGFloat?
	
	var limitPoints: [LimitPoint]?
	
	override func draw(_ rect: CGRect) {
		
		let context = UIGraphicsGetCurrentContext()!
		
		if let dominantFrequencies = dominantFrequencies {
			addPointForDominantFrequencies(rect: rect, dominantFrequencies: dominantFrequencies)
		}
		
		UIColor.black.setFill()
		
		context.drawPath(using: .fill)
		context.strokePath()
		
		if let limitPoints = limitPoints {
			drawLimitLines(rect: rect, limitPoints: limitPoints)
		}
		
		super.draw(rect)
	}
	
	func addPointForDominantFrequencies(rect: CGRect, dominantFrequencies: [(DominantFrequency, DominantFrequency, DominantFrequency)]) {

		var maxFrequency = (0, 0, 0)
		var maxVelocity: (Float, Float, Float) = (0.0, 0.0, 0.0)
		for (xDimension, yDimension, zDimension) in dominantFrequencies {
			maxFrequency.0 = max(xDimension.frequency, maxFrequency.0)
			maxVelocity.0 = max(xDimension.velocity, maxVelocity.0)
			
			maxFrequency.1 = max(yDimension.frequency, maxFrequency.1)
			maxVelocity.1 = max(yDimension.velocity, maxVelocity.1)
			
			maxFrequency.2 = max(zDimension.frequency, maxFrequency.2)
			maxVelocity.2 = max(zDimension.velocity, maxVelocity.2)
		}
		
		for value in dominantFrequencies {
			xDataSet.append(BubbleChartDataEntry(x: Double(value.0.frequency),
												 y: abs(Double(value.0.velocity * 1000)), size: 3.0))
			yDataSet.append(BubbleChartDataEntry(x: Double(value.1.frequency),
												 y: abs(Double(value.1.velocity * 1000)), size: 3.0))
			zDataSet.append(BubbleChartDataEntry(x: Double(value.2.frequency),
												 y: abs(Double(value.2.velocity * 1000)), size: 3.0))
		}
		
		let data = BubbleChartData(dataSets: [xDataSet, yDataSet, zDataSet])
		
		self.data = data
		
	}
	
	func drawLimitLines(rect: CGRect, limitPoints: [LimitPoint]) {
		var limit = limitPoints
		
		let maxX = limit.map({return $0.xValue}).max()
		let maxY = limit.map({return $0.yValue}).max()
		
		if let maxX = maxX, let maxY = maxY {
			let context = UIGraphicsGetCurrentContext()
			
			let scaleFactorX = CGFloat(maxX) / rect.width
			let scaleFactorY = CGFloat(maxY) / rect.height
			
			context?.beginPath()
			
			context?.setLineWidth(3.0)
			UIColor.black.setStroke()
			
			context?.move(to: CGPoint(x: CGFloat(limit[0].xValue) * scaleFactorX,
									  y: rect.height - CGFloat(limit[0].yValue) * scaleFactorY))
			limit.remove(at: 0)
			
			for point in limit {
				
				let scaledX = CGFloat(point.xValue)
				let scaledY = CGFloat(point.yValue)
				
				context?.addLine(to: CGPoint(x: scaledX, y: rect.height - scaledY))
			}
			
			if let lastPoint = limit.last {
				context?.addLine(to: CGPoint(x: rect.width, y: rect.height - CGFloat(lastPoint.yValue)))
			}
			
			context?.strokePath()
			
		}
	}
}
