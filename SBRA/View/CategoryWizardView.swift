//
//  CategoryWizardView.swift
//  SBRA
//
//  Created by Wander Siemers on 06/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class CategoryWizardView: UIView {
	
	var textLabel: UILabel
	var secondaryTextLabel: UILabel
	var yesButton: UIButton
	var noButton: UIButton
	
	override init(frame: CGRect) {
		textLabel = UILabel(frame: .zero)
		secondaryTextLabel = UILabel(frame: .zero)
		yesButton = UIButton.init(type: .system)
		noButton = UIButton.init(type: .system)

		super.init(frame: frame)
		
		textLabel.numberOfLines = 0
		secondaryTextLabel.numberOfLines = 0
		
		addSubview(textLabel)
		addSubview(secondaryTextLabel)
		
		textLabel.text = "Bestaat het gebouw waarin u wilt meten uit een betonnen bebouwing met metselwerk of gevelbekleding?"
		textLabel.font = UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)
		secondaryTextLabel.text = "Veel bebouwing van na 1970 heeft hiv net als deze categorie."
		secondaryTextLabel.font = UIFont.italicSystemFont(ofSize: textLabel.font.pointSize)
		
		yesButton.setTitle("Ja", for: .normal)
		noButton.setTitle("Nee", for: .normal)
		yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
		noButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
		
		yesButton.tintColor = .white
		noButton.tintColor = .white
		yesButton.backgroundColor = .buttonGreen
		noButton.backgroundColor = .buttonRed
		
		yesButton.layer.cornerRadius = 8.0
		noButton.layer.cornerRadius = 8.0
		
		addSubview(yesButton)
		addSubview(noButton)
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
		yesButton.translatesAutoresizingMaskIntoConstraints = false
		noButton.translatesAutoresizingMaskIntoConstraints = false
		
		setupConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			textLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
			textLabel.rightAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.rightAnchor),
			textLabel.topAnchor.constraint(equalToSystemSpacingBelow: layoutMarginsGuide.topAnchor, multiplier: 3.0),
			
			secondaryTextLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
			secondaryTextLabel.rightAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.rightAnchor),
			secondaryTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: textLabel.bottomAnchor, multiplier: 1.0),
			
			yesButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			yesButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: secondaryTextLabel.bottomAnchor,
										   multiplier: 2.0),
			yesButton.heightAnchor.constraint(equalToConstant: 48.0),
			yesButton.widthAnchor.constraint(equalToConstant: 210.0),
			
			noButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			noButton.topAnchor.constraint(equalToSystemSpacingBelow: yesButton.bottomAnchor, multiplier: 2.0),
			noButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -50.0),
			noButton.heightAnchor.constraint(equalTo: yesButton.heightAnchor),
			noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor)
		])
	}
}
