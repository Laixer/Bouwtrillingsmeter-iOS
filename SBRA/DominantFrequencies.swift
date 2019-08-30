//
//  DominantFrequencies.swift
//  SBRA
//
//  Created by Anonymous on 27-08-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

import Foundation

class DominantFrequencies {
    
    private var frequencies: [Float]?
    private var velocities: [Float]?
    private var exceedsLimit: [Bool]?
    
    init(frequencies: [Float], velocities: [Float], exceedsLimit: [Bool]) {
        self.frequencies = frequencies
        self.velocities = velocities
        self.exceedsLimit = exceedsLimit
    }
    
    public func isExceedingLimit() -> Bool {
        for bool in exceedsLimit! {
            if bool {
                return true
            }
        }
        return false
    }
    
    public func getFrequencies() -> [Float] {
        return frequencies!
    }
    
    public func getVelocities() -> [Float] {
        return velocities!
    }
    
    public func getExceedsLimit() -> [Bool] {
        return exceedsLimit!
    }
    
}
