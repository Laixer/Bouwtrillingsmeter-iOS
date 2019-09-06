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
	var resultsView: CategoryWizardResultsView?

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
			if let question = currentItem as? WizardQuestion {
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
						result.isSensitiveToVibrations = sensitivityCategory
						showResultsView()
						delegate?.categoryWizardDelegateDidPick(settings: result)
					}
					
					if outcome.successful == false {
						delegate?.categoryWizardDelegateDidFailWithMessage(message: outcome.text)
                        wizardView?.secondaryTextLabel.text = ""
						showFailureResultsView()
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
	
	private func showResultsView() {
		let resultsView = CategoryWizardResultsView(frame: CGRect(x: 0.0,
																  y: 100.0,
																  width: view.bounds.width,
																  height: view.bounds.width))
		
		resultsView.buildingCategoryLabel.text = result.buildingCategory?.rawValue
		resultsView.vibrationCategoryLabel.text = result.vibrationCategory?.rawValue
		if let sensitive = result.isSensitiveToVibrations {
			resultsView.sensitiveToVibrationsLabel.text = sensitive ? "Ja" : "Nee"
		}
	
		view.addSubview(resultsView)
		
		resultsView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			resultsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			resultsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			resultsView.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 3.0),
			resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
		
		wizardView?.yesButton.isHidden = true
		wizardView?.noButton.isHidden = true
		
		self.resultsView = resultsView
	}
	
	private func showFailureResultsView() {
		wizardView?.yesButton.isHidden = true
		wizardView?.noButton.isHidden = true
		
		wizardView?.textLabel.text = currentWizardItem?.text
	}
}
