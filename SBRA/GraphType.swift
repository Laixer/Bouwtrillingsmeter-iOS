//
//  GraphType.swift
//  SBRA
//
//  Created by Wander Siemers on 26/11/2018.
//  Copyright © 2018 Wander Siemers. All rights reserved.
//

enum GraphType: CaseIterable, CustomStringConvertible {
	case SpeedTime
	case FrequencyTime
	case SpeedFrequency
	case FFTDisplacement
	case GravityTimeAccelerationTime
	
	var description: String {
		switch self {
		case .SpeedTime:
			return "Snelheid/tijd"
		case .FrequencyTime:
			return "Frequentie/tijd"
		case .SpeedFrequency:
			return "Snelheid/frequentie"
		case .FFTDisplacement:
			return "FFT/plaats"
		case .GravityTimeAccelerationTime:
			return "Zwaartekracht/tijd + Versnelling/tijd"
		}
	}
}
