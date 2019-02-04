//
//  WizardQuestion.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//


/**
WizardQuestion is a wizard item which has a succeeding item, useful for questions.
*/
class WizardQuestion: WizardItem {
	var text: String
	var secondaryText: String?
	var positiveNext: WizardItem?
	var negativeNext: WizardItem?
	
	init(text: String, secondaryText: String?, positiveNext: WizardItem?, negativeNext: WizardItem?) {
		self.text = text
		self.secondaryText = secondaryText
		self.positiveNext = positiveNext
		self.negativeNext = negativeNext
	}
}
