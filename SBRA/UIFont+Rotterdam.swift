//
//  UIFont+Rotterdam.swift
//  SBRA
//
//  Created by Wander Siemers on 03/12/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import UIKit

extension UIFont {
	class var rotterdamNavigationTitleFont: UIFont {
		let font = UIFont(name: "Arial", size: 0)!
		let fontMetrics = UIFontMetrics(forTextStyle: .headline)
		return fontMetrics.scaledFont(for: font)
	}
}
