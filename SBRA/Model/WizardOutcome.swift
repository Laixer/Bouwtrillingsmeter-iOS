//
//  WizardOutcome.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

/**
WizardOutcome is a wizard item which doesn't have successor in the graph, useful for outcomes. A WizardOutcome can be denoted successful/unsuccessful. By default, it's successful.
*/
class WizardOutcome: WizardItem {
	var text: String
	var successful: Bool = true
	
	init(text: String) {
		self.text = text
	}
	
	init(text: String, isPositive: Bool) {
		self.text = text
		self.successful = isPositive
	}
}
