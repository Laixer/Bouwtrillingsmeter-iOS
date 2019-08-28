//
//  NSDate+Epoch.swift
//  SBRA
//
//  Created by Anonymous on 28-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation


extension NSDate {
    func getCurrentMillis() -> Int64 {
        return  Int64(self.timeIntervalSince1970 * 1000)
    }
}
