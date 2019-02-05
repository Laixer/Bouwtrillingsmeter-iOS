//
//  SwitchTableViewCell.swift
//  SBRA
//
//  Created by Wander Siemers on 17/01/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
	
	var switchElement: UISwitch
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		switchElement = UISwitch(frame: CGRect.zero)
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		if let textLabel = self.textLabel {			
			switchElement.isOn = false
			
			switchElement.translatesAutoresizingMaskIntoConstraints = false
			textLabel.translatesAutoresizingMaskIntoConstraints = false
			
			
			contentView.addSubview(switchElement)
			contentView.addSubview(textLabel)
			
			NSLayoutConstraint.activate([
				textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15.0),
				textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
				switchElement.centerYAnchor.constraint(equalTo: centerYAnchor),
				switchElement.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
				
				])
		}
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
