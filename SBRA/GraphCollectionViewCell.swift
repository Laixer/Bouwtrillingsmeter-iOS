//
//  GraphCollectionViewCell.swift
//  SBRA
//
//  Created by Wander Siemers on 25/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit
import simd

class GraphCollectionViewCell: UICollectionViewCell {
	private var graphTypeLabel = UILabel()
	var text: String? {
		didSet {
			graphTypeLabel.text = text
		}
	}
	var graphView = GraphView(frame: CGRect.zero)
	
	func addValues(values: double3) {
		graphView.add(values)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		clipsToBounds = true
		
		addSubview(graphTypeLabel)
		addSubview(graphView)
		
		graphView.frame = CGRect(x: 0, y: 10, width: frame.width, height: frame.height - 10)
		//graphView.backgroundColor = UIColor.blue
	}
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
