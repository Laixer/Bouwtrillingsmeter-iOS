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
		
		graphTypeLabel.textColor = UIColor.white
		graphTypeLabel.numberOfLines = 0
		graphTypeLabel.textAlignment = .center
		
		contentView.addSubview(graphTypeLabel)
		contentView.addSubview(graphView)
		
		let height = floor(0.4 * frame.height)
		// graphView.backgroundColor = UIColor.black
		graphView.frame = CGRect(x: 0, y: frame.height - height, width: frame.width, height: height)
		//graphView.backgroundColor = UIColor.blue
		
		setupConstraints()
	}
	
	func setupConstraints() {
		graphTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		
		graphTypeLabel.allowsDefaultTighteningForTruncation = true
		
		graphTypeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.0).isActive = true
		graphTypeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8.0).isActive = true
		graphTypeLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1.0).isActive = true
	}
	
	override func draw(_ rect: CGRect) {
		graphTypeLabel.text = text
	}
	
	
	
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
