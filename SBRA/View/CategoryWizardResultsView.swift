//
//  CategoryWizardResultsView.swift
//  SBRA
//
//  Created by Wander Siemers on 06/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class CategoryWizardResultsView: UIView {
	private var textLabel: UILabel
	
	private var buildingStackView: UIStackView
	private var vibrationStackView: UIStackView
	private var sensitiveStackView: UIStackView
	
	private var buildingCategoryHeader: UILabel
	private var vibrationCategoryHeader: UILabel
	private var sensitiveToVibrationsHeader: UILabel

	var buildingCategoryLabel: UILabel
	var vibrationCategoryLabel: UILabel
	var sensitiveToVibrationsLabel: UILabel
	
	override init(frame: CGRect) {
		textLabel = UILabel()
		textLabel.textAlignment = .center
		textLabel.numberOfLines = 0
		
		buildingCategoryHeader = UILabel()
		vibrationCategoryHeader = UILabel()
		sensitiveToVibrationsHeader = UILabel()
		
		buildingCategoryLabel = UILabel()
		vibrationCategoryLabel = UILabel()
		sensitiveToVibrationsLabel = UILabel()
		
		buildingCategoryLabel.textAlignment = .right
		vibrationCategoryLabel.textAlignment = .right
		sensitiveToVibrationsLabel.textAlignment = .right
		
		let size = buildingCategoryLabel.font.pointSize
		buildingCategoryHeader.font = UIFont.boldSystemFont(ofSize: size)
		vibrationCategoryHeader.font = UIFont.boldSystemFont(ofSize: size)
		sensitiveToVibrationsHeader.font = UIFont.boldSystemFont(ofSize: size)

		buildingStackView = UIStackView(arrangedSubviews: [buildingCategoryHeader, buildingCategoryLabel])
		vibrationStackView = UIStackView(arrangedSubviews: [vibrationCategoryHeader, vibrationCategoryLabel])
		sensitiveStackView = UIStackView(arrangedSubviews: [sensitiveToVibrationsHeader, sensitiveToVibrationsLabel])
		
		textLabel.text = "Aan de hand van uw antwoorden is het volgende bepaald:"
		buildingCategoryHeader.text = "Categorie pand"
		vibrationCategoryHeader.text = "Categorie trilling"
		sensitiveToVibrationsHeader.text = "Trillingsgevoelig"
		
		super.init(frame: frame)
		
		backgroundColor = .white
				
		addSubview(textLabel)
		
		addSubview(buildingStackView)
		addSubview(vibrationStackView)
		addSubview(sensitiveStackView)
		
		setupStackView()
		setupConstraints()
		setupAutoLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupStackView() {
		let distribution = UIStackView.Distribution.fillProportionally
		let axis = NSLayoutConstraint.Axis.horizontal
		let alignment = UIStackView.Alignment.firstBaseline
		
		buildingStackView.axis = axis
		buildingStackView.alignment = alignment
		buildingStackView.distribution = distribution
		
		vibrationStackView.axis = axis
		vibrationStackView.alignment = alignment
		vibrationStackView.distribution = distribution
		
		sensitiveStackView.axis = axis
		sensitiveStackView.alignment = alignment
		sensitiveStackView.distribution = distribution
	}
	
	private func setupAutoLayout() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false

		buildingCategoryHeader.setContentHuggingPriority(.required, for: .horizontal)
		vibrationCategoryHeader.setContentHuggingPriority(.required, for: .horizontal)
		sensitiveToVibrationsHeader.setContentHuggingPriority(.required, for: .horizontal)
		
		buildingStackView.translatesAutoresizingMaskIntoConstraints = false
		vibrationStackView.translatesAutoresizingMaskIntoConstraints = false
		sensitiveStackView.translatesAutoresizingMaskIntoConstraints = false
		
		buildingCategoryHeader.translatesAutoresizingMaskIntoConstraints = false
		vibrationCategoryHeader.translatesAutoresizingMaskIntoConstraints = false
		sensitiveToVibrationsHeader.translatesAutoresizingMaskIntoConstraints = false
		
		buildingCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
		vibrationCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
		sensitiveToVibrationsLabel.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			textLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1.0),
			textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
			textLabel.leftAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: layoutMarginsGuide.leftAnchor,
											multiplier: 1.0),
			textLabel.rightAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: layoutMarginsGuide.rightAnchor,
											 multiplier: 1.0),
			
			buildingStackView.topAnchor.constraint(equalToSystemSpacingBelow: textLabel.bottomAnchor, multiplier: 4.0),
			vibrationStackView.topAnchor.constraint(equalToSystemSpacingBelow: buildingStackView.bottomAnchor, multiplier: 1.0),
			sensitiveStackView.topAnchor.constraint(equalToSystemSpacingBelow: vibrationStackView.bottomAnchor, multiplier: 1.0),
			
			buildingStackView.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 3.0),
			buildingStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
			vibrationStackView.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 3.0),
			vibrationStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
			sensitiveStackView.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 3.0),
			sensitiveStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
			
		])
	}
}
