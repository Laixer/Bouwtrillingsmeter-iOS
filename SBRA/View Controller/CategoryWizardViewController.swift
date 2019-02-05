//
//  CategoryWizardViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class CategoryWizardViewController: UIViewController {
	
	var currentWizardItem: WizardItem?
	var textLabel: UILabel?
	var secondaryTextLabel: UILabel?
	
	var delegate: CategoryWizardDelegate?
	
	var result: MeasurementSettings = MeasurementSettings()
	
	var yesButton: UIButton?
	var noButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
	
	private func setupUI() {
		title = "Bepaling instellingen"
		view.backgroundColor = .white
		
		let textLabel = UILabel(frame: .zero)
		textLabel.numberOfLines = 0
		let secondaryTextLabel = UILabel(frame: .zero)
		secondaryTextLabel.numberOfLines = 0
		
		view.addSubview(textLabel)
		view.addSubview(secondaryTextLabel)
		
		textLabel.text = "Bestaat het gebouw waarin u wilt meten uit een betonnen bebouwing met metselwerk of gevelbekleding?"
		textLabel.font = UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)
		secondaryTextLabel.text = "Veel bebouwing van na 1970 heeft hiv net als deze categorie."
		secondaryTextLabel.font = UIFont.italicSystemFont(ofSize: textLabel.font.pointSize)
		
		if let item = currentWizardItem as? WizardQuestion {
			textLabel.text = item.text
			secondaryTextLabel.text = item.secondaryText
		}
		
		let yesButton = UIButton.init(type: .system)
		let noButton = UIButton.init(type: .system)
		
		yesButton.setTitle("Ja", for: .normal)
		noButton.setTitle("Nee", for: .normal)
		if let label = yesButton.titleLabel {
			label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
		}
		
		if let label = noButton.titleLabel {
			label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
		}
		
		yesButton.tintColor = .white
		noButton.tintColor = .white
		yesButton.backgroundColor = .buttonGreen
		noButton.backgroundColor = .buttonRed
		
		yesButton.layer.cornerRadius = 8.0
		noButton.layer.cornerRadius = 8.0
		
		yesButton.addTarget(self, action: #selector(tappedYesButton), for: .touchUpInside)
		noButton.addTarget(self, action: #selector(tappedNoButton), for: .touchUpInside)
		
		view.addSubview(yesButton)
		view.addSubview(noButton)
		
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
		yesButton.translatesAutoresizingMaskIntoConstraints = false
		noButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			textLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
			textLabel.rightAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.rightAnchor),
			textLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 3.0),
			
			secondaryTextLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
			secondaryTextLabel.rightAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.rightAnchor),
			secondaryTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: textLabel.bottomAnchor, multiplier: 1.0),
			
			yesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			yesButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: secondaryTextLabel.bottomAnchor, multiplier: 5.0),
			yesButton.heightAnchor.constraint(equalToConstant: 48.0),
			yesButton.widthAnchor.constraint(equalToConstant: 210.0),
			
			noButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			noButton.topAnchor.constraint(equalToSystemSpacingBelow: yesButton.bottomAnchor, multiplier: 2.0),
			noButton.heightAnchor.constraint(equalTo: yesButton.heightAnchor),
			noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor),
		])
		
		self.textLabel = textLabel
		self.secondaryTextLabel = secondaryTextLabel
		self.yesButton = yesButton
		self.noButton = noButton
	}
	
	@objc private func tappedYesButton() {
		handleButtonTap(positive: true)
	}
	
	@objc private func tappedNoButton() {
		handleButtonTap(positive: false)
	}
	
	private func handleButtonTap(positive: Bool) {
		
		if let currentItem = currentWizardItem {
			//print(currentItem.text)
			
			if let question = currentItem as? WizardQuestion {
				// save state for question
				
				currentWizardItem = positive ? question.positiveNext : question.negativeNext
				if (currentWizardItem as? WizardQuestion) != nil {
					updateUI()
				} else if let outcome = currentWizardItem as? WizardOutcome {
					if let buildingCategory = outcome.buildingCategory {
						result.buildingCategory = buildingCategory
					}
					if let vibrationCategory = outcome.vibrationCategory {
						result.vibrationCategory = vibrationCategory
					}
					if let sensitivityCategory = outcome.sensitiveToVibrations {
						result.sensitiveToVibrations = sensitivityCategory
						delegate?.categoryWizardDelegateDidPick(settings: result)
					}
					
					if (outcome.successful == false) {
						delegate?.categoryWizardDelegateDidFailWithMessage(message: outcome.text)
					}
					
					currentWizardItem = outcome.next
					updateUI()
				}
			}
			
			if let outcome = currentItem as? WizardOutcome {
				currentWizardItem = outcome.next
				updateUI()
			}
		}
		
		
	}
	
	private func updateUI() {
		if let question = currentWizardItem as? WizardQuestion {
			textLabel?.text = question.text
			secondaryTextLabel?.text = question.secondaryText
		}
		
	}
}
