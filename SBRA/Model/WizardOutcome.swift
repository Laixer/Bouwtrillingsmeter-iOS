//
//  WizardOutcome.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

/**
WizardOutcome is a wizard item which doesn't have successor in the graph, useful for outcomes.
A WizardOutcome can be denoted successful/unsuccessful. By default, it's successful.
*/
class WizardOutcome: WizardItem {
	var text: String
	var successful: Bool = true
	var next: WizardQuestion?
	var buildingCategory: BuildingCategory?
	var vibrationCategory: VibrationCategory?
	var sensitiveToVibrations: Bool?
	
	init(text: String) {
		self.text = text
	}
	
	convenience init(text: String, isPositive: Bool) {
		self.init(text: text)
		self.successful = isPositive
	}
	
	convenience init(text: String, buildingCategory: BuildingCategory) {
		self.init(text: text)
		self.buildingCategory = buildingCategory
	}
	
	convenience init(text: String, vibrationCategory: VibrationCategory) {
		self.init(text: text)
		self.vibrationCategory = vibrationCategory
	}
	
	convenience init(text: String, sensitiveToVibrations: Bool) {
		self.init(text: text)
		self.sensitiveToVibrations = sensitiveToVibrations
	}
}
