//
//  PowerLimit.swift
//  SBRA
//
//  Created by Wander Siemers on 12/05/2019.
//  Copyright © 2019 Wander Siemers. All rights reserved.
//

import Foundation
import Charts

struct LimitPoint {
	var xValue: Float
	var yValue: Float
	
	init(xValue: Float, yValue: Float) {
		self.xValue = xValue
		self.yValue = yValue
	}
}

private enum YVFactor {
	case indicative
	case limited
	case vibrationSensitive
	
	var value: Float {
		switch self {
		case .indicative: return 1.6
		case .limited: return 1.4
		case .vibrationSensitive: return 1.0
		}
		
	}
	
	init?(from measurementSettings: MeasurementSettings) {
		self = .vibrationSensitive
	}
}

private enum YTFactor {
	case shortVibration
	case shortVibrationRepeated
	case continousVibration
	case vibrationSensitive
	
	var value: Float {
		switch self {
		case .shortVibration: return 1.0
		case .shortVibrationRepeated: return 1.5
		case .continousVibration: return 2.5
		case .vibrationSensitive: return 1.0
		}
	}
}

struct PowerLimit {
	
	static func limitForSettings(settings: MeasurementSettings) -> [LimitPoint] {
		let amplitudes = amplitudesForSettings(settings: settings)
		
		var limits = [LimitPoint]()
		let yvFactor = YVFactor(from: settings)
		
		for (index, value) in frequencyValues.enumerated() {
			if let amplitude = amplitudes?[index], let yvFactor = yvFactor {
				limits.append(LimitPoint(xValue: value, yValue: amplitude * yvFactor.value))
			} else {
				fatalError("can't find amplitude value")
			}
		}
		
		return limits
	}
	
	static func limitForSettings(settings: MeasurementSettings) -> [[Float]] {
		let yvFactor = YVFactor(from: settings)
		
		if var amplitudes = amplitudesForSettings(settings: settings), let factor = yvFactor?.value {
			for index in amplitudes.indices {
				amplitudes[index] = amplitudes[index] * factor
			}
			
			return [frequencyValues, amplitudes]
		} else {
			fatalError("illegal amplitudes or yv factor")
		}
		
	}
    
    static func getLimitAsEntries(settings: MeasurementSettings) -> [ChartDataEntry] {
        
        var amplitudes = amplitudesForSettings(settings: settings)
        var yt = YVFactor(from: settings)
        
        var result: [ChartDataEntry] = []
        for index in 0..<frequencyValues.count {
            result.append(ChartDataEntry(x: Double(frequencyValues[index]), y: Double(amplitudes![index] * yt!.value)))
        }
        
        return result
        
    }
	
	private static let frequencyValues: [Float] = [0, 10, 50, 100]
	
	private static let shortVibrationAmplitudes: [[Float]] = [[20, 20, 40, 50],
												   [5, 5, 15, 20],
												   [3, 3, 8, 10]]
	
	private static let repeatedShortVibrationAmplitudes: [[Float]] = [[(13.33333), (13.33333), (26.66666), (33.33333)],
														   [(3.33333), (3.33333), 10, (13.33333)],
														   [2, 2, 5.33333, (6.66666)]]
	
	private static let continuousVibrationAmplitudes: [[Float]] = [[10, 10, 20, 25],
														[2.5, 2.5, 7.5, 10],
														[1.5, 1.5, 4, 5]]
	
	private static func amplitudesForSettings(settings: MeasurementSettings) -> [Float]? {
		var index: Int?
		if let buildingCategory = settings.buildingCategory {
			switch buildingCategory {
			case .category1: index = 0
			case .category2: index = 1
			case .category3: index = 2
			}
		}
		
		if let index = index {
			if let vibrationCategory = settings.vibrationCategory {
				switch vibrationCategory {
				case .shortDuration: return shortVibrationAmplitudes[index]
				case .repeatedShortDuration: return repeatedShortVibrationAmplitudes[index]
				case .continuous: return continuousVibrationAmplitudes[index]
				}
			}
		}
		
		return nil
	}
}
