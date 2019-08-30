//
//  GraphType.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

enum GraphType: CaseIterable, CustomStringConvertible {
    case accelerationTime
	case highestVelocityTime
    case dominantFrequencyTime
	case amplitudeFrequency
	case dominantFrequencyFrequency
	
	
	var description: String {
		switch self {
		case .accelerationTime:
			return "Versnellingsdiagram"
		case .highestVelocityTime:
			return "Snelheidsdiagram"
		case .dominantFrequencyTime:
			return "Dominante frequentie continu"
		case .amplitudeFrequency:
			return "Frequentiespectrum"
		case .dominantFrequencyFrequency:
			return "Dominante frequentie"
		}
	}
    
    var xDescription: String {
        switch self {
        case .accelerationTime:
            return "Tijd [s]"
        case .highestVelocityTime:
            return "Tijd [s]"
        case .dominantFrequencyTime:
            return "Tijd [s]"
        case .amplitudeFrequency:
            return "Frequentie [Hz]"
        case .dominantFrequencyFrequency:
            return "Frequentie [Hz]"
        }
    }
    
    var yDescription: String {
        switch self {
        case .accelerationTime:
            return "Versnelling [mm/s2]"
        case .highestVelocityTime:
            return "Snelheid [mm/s]"
        case .dominantFrequencyTime:
            return "(Dominante) frequentie [Hz]"
        case .amplitudeFrequency:
            return "Amplitude (snelheid) [mm/s]"
        case .dominantFrequencyFrequency:
            return "Amplitude (snelheid) [mm/s]"
        }
    }
}
