//
//  GraphSegment.swift
//  SBRA
//
//  Created by Wander Siemers on 16/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class GraphSegment: UIView {
	
	var singleLine = false

	static let capacity = 32
	
	private(set) var dataPoints = [double3]()
	
	private let startPoint: double3
	
	private let valueRanges: [ClosedRange<Double>]
	
	var lineColors: [UIColor] = [.white, .white, .white]
	
	var gridLinePositions = [CGFloat]()
	
	var isFull: Bool {
		return dataPoints.count >= GraphSegment.capacity
	}
	
	// MARK: Initialization
	
	init(startPoint: double3, valueRanges: [ClosedRange<Double>]) {
		self.startPoint = startPoint
		self.valueRanges = valueRanges
		
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func add(_ values: double3) {
		guard dataPoints.count < GraphSegment.capacity else { return }
		
		dataPoints.append(values)
		setNeedsDisplay()
	}
	
	// MARK: UIView
	
	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		// Fill the background.
		if let backgroundColor = backgroundColor?.cgColor {
			context.setFillColor(backgroundColor)
			context.fill(rect)
		}
		
		// Draw static lines.
		//context.drawGraphLines(in: bounds.size)
		
		// Plot lines for the 3 sets of values.
		context.setShouldAntialias(true)
		context.translateBy(x: 0, y: bounds.size.height / 2.0)
		
		let maxIndex = singleLine ? 1 : 3
		for lineIndex in 0..<maxIndex {
			context.setStrokeColor(lineColors[lineIndex].cgColor)
			
			// Move to the start point for the current line.
			let value = startPoint[lineIndex]
			let point = CGPoint(x: bounds.size.width, y: scaledValue(for: lineIndex, value: value))
			context.move(to: point)
			
			// Draw lines between the data points.
			for (pointIndex, dataPoint) in dataPoints.enumerated() {
				let value = dataPoint[lineIndex]
				let point = CGPoint(x: bounds.size.width - CGFloat(pointIndex + 1), y: scaledValue(for: lineIndex, value: value))
				
				context.addLine(to: point)
			}
			
			context.strokePath()
		}
	}
	
	private func scaledValue(for lineIndex: Int, value: Double) -> CGFloat {
		// For simplicity, this assumes the range is centered on zero.
		let valueRange = valueRanges[lineIndex]
		let scale = Double(bounds.size.height) / (valueRange.upperBound - valueRange.lowerBound)
		return CGFloat(floor(value * -scale))
	}

}
