//
//  CategoryWizardDelegate.swift
//  SBRA
//
//  Created by Wander Siemers on 05/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

protocol CategoryWizardDelegate {
	func categoryWizardDelegateDidPick(settings: MeasurementSettings)
	func categoryWizardDelegateDidFailWithMessage(message: String)
}
