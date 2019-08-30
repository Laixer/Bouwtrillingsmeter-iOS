//
//  DataPoint.swift
//  SBRA
//
//  Created by Wander Siemers on 24/10/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

import CoreMotion

struct DataPoint<T: Numeric> {
    var xAxisValue: T
    var values: [Float]
    
    func xAXisValueAsDouble() -> Double {
        
        var valueToReturn: Double
        
        valueToReturn = Double(parseToLong(number: xAxisValue))
        if valueToReturn < 0 {
            valueToReturn = parseToDouble(number: xAxisValue)
        }
        
        return valueToReturn
    }
    
    private func parseToLong(number: T) -> Int64{
        return xAxisValue as? Int64 ?? -1
    }
    
    private func parseToDouble(number: T) -> Double{
        return xAxisValue as? Double ?? -1
    }
    
}
