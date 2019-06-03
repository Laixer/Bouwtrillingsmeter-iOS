//
//  DominantFrequencyGraphView.swift
//  SBRA
//
//  Created by Wander Siemers on 03/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class DominantFrequencyGraphView: GraphView {
	
	var dominantFrequencies: [(DominantFrequency, DominantFrequency, DominantFrequency)]?
	
	var yMax: CGFloat?
	var xMax: CGFloat?
	
	var limitPoints: [LimitPoint]?
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let context = UIGraphicsGetCurrentContext()!
		
		if let dominantFrequencies = dominantFrequencies {
			addPointForDominantFrequencies(rect: rect, dominantFrequencies: dominantFrequencies.map({$0.0}))
			addPointForDominantFrequencies(rect: rect, dominantFrequencies: dominantFrequencies.map({$0.1}))
			addPointForDominantFrequencies(rect: rect, dominantFrequencies: dominantFrequencies.map({$0.2}))
		}
		
		UIColor.black.setFill()
		
		context.drawPath(using: .fill)
		context.strokePath()
		
		if let limitPoints = limitPoints {
			drawLimitLines(rect: rect, limitPoints: limitPoints)
		}
		
		setNeedsDisplay()
	}
	
	func addPointForDominantFrequencies(rect: CGRect, dominantFrequencies: [DominantFrequency]) {
		let context = UIGraphicsGetCurrentContext()!
		
		var maxFrequency = 0
		var maxVelocity: Float = 0.0
		for value in dominantFrequencies {
			maxFrequency = max(value.frequency, maxFrequency)
			maxVelocity = max(value.velocity, maxVelocity)
		}
		
		for value in dominantFrequencies {
			context.addEllipse(in: CGRect(x: CGFloat(value.frequency) /*/ CGFloat(maxFrequency) * rect.width*/,
				y: rect.height - CGFloat(value.velocity * 1000.0) /*/ CGFloat(maxVelocity) *  rect.height*/,
				width: 3.0,
				height: 3.0))
		}
		
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
			
			context?.move(to: CGPoint(x: CGFloat(limit[0].xValue) * scaleFactorX, y: rect.height - CGFloat(limit[0].yValue) * scaleFactorY))
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
