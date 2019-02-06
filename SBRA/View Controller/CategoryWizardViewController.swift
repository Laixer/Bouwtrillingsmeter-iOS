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
	weak var delegate: CategoryWizardDelegate?
	var result: MeasurementSettings = MeasurementSettings()
	
	var wizardView: CategoryWizardView?

    override func viewDidLoad() {
        super.viewDidLoad()
		setupUI()
    }
	
	private func setupUI() {
		title = "Bepaling instellingen"
		
		let wizardView = CategoryWizardView()
		view = wizardView
		view.backgroundColor = .white
		self.wizardView = wizardView
		
		if let item = currentWizardItem as? WizardQuestion {
			wizardView.textLabel.text = item.text
			wizardView.secondaryTextLabel.text = item.secondaryText
		}
		
		wizardView.yesButton.addTarget(self, action: #selector(tappedYesButton), for: .touchUpInside)
		wizardView.noButton.addTarget(self, action: #selector(tappedNoButton), for: .touchUpInside)
		
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
					
					if outcome.successful == false {
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
			wizardView?.textLabel.text = question.text
			wizardView?.secondaryTextLabel.text = question.secondaryText
		}
	}
}
