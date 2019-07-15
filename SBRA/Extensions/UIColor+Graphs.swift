//
//  UIColor+Graphs.swift
//  SBRA
//
//  Created by Wander Siemers on 21/06/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import UIKit

extension UIColor {
	class var xDimensionColor: UIColor {
		return UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
	}
	
	class var yDimensionColor: UIColor {
		return UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
	}
	
	class var zDimensionColor: UIColor {
		return UIColor(displayP3Red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
	}
}
