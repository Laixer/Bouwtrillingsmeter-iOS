//
//  GraphType.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

enum GraphType: CaseIterable, CustomStringConvertible {
	case speedTime
	case frequencyTime
	case dominantFrequency
	case fft1Second
	case gravityTimeAccelerationTime
	
	var description: String {
		switch self {
		case .speedTime:
			return "Snelheid/tijd"
		case .frequencyTime:
			return "Frequentie/tijd"
		case .dominantFrequency:
			return "Dominante frequentie"
		case .fft1Second:
			return "FFT (1 seconde)"
		case .gravityTimeAccelerationTime:
			return "Zwaartekracht/tijd + Versnelling/tijd"
		}
	}
    
    var xDescription: String {
        switch self {
        case .speedTime:
            return "Snelheid/tijd"
        case .frequencyTime:
            return "Frequentie/tijd"
        case .dominantFrequency:
            return "Dominante frequentie"
        case .fft1Second:
            return "FFT (1 seconde)"
        case .gravityTimeAccelerationTime:
            return "Zwaartekracht/tijd + Versnelling/tijd"
        }
    }
    
    var yDescription: String {
        switch self {
        case .speedTime:
            return "Snelheid/tijd"
        case .frequencyTime:
            return "Frequentie/tijd"
        case .dominantFrequency:
            return "Dominante frequentie"
        case .fft1Second:
            return "FFT (1 seconde)"
        case .gravityTimeAccelerationTime:
            return "Zwaartekracht/tijd + Versnelling/tijd"
        }
    }
}
