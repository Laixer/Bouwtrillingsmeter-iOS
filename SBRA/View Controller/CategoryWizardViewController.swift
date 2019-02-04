//
//  CategoryWizardViewController.swift
//  SBRA
//
//  Created by Wander Siemers on 04/02/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class CategoryWizardViewController: UIViewController {
	
	var wizardItem: WizardItem?

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
		
		if let item = wizardItem as? WizardQuestion {
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

	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
