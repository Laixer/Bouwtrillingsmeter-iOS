//
//  FFT_New.swift
//  SBRA
//
//  Created by Anonymous on 04-09-19.
//  Copyright © 2019 James Bal. All rights reserved.
//

// swiftlint:disable identifier_name

import Accelerate

class FFT {

    public static func create(_ input: [Float]) -> [Float] {
        var real = [Float](input)
        
        // adding to given input of 100 entries to add up to next ˆ2
        for i in 0..<128 - input.count {
            real.append(0.0)
        }
        var imaginary = [Float](repeating: 0.0, count: real.count)
        var splitComplex = DSPSplitComplex(realp: &real, imagp: &imaginary)
        
        var exponent = vDSP_Length(floor(log2(Float(input.count))) + 1)
        // hard code because of the new ˆ2 + 1
        exponent = 7
        let radix = FFTRadix(kFFTRadix2)
        let weights = vDSP_create_fftsetup(exponent, radix)
        withUnsafeMutablePointer(to: &splitComplex) { splitComplex in
            vDSP_fft_zip(weights!, splitComplex, 1, exponent, FFTDirection(FFT_FORWARD))
        }
        
        // changed count according to real array
        var magnitudes = [Float](repeating: 0.0, count: real.count)
        withUnsafePointer(to: &splitComplex) { splitComplex in
            magnitudes.withUnsafeMutableBufferPointer { magnitudes in
                vDSP_zvmags(splitComplex, 1, magnitudes.baseAddress!, 1, vDSP_Length(real.count))
            }
        }
        
        vDSP_destroy_fftsetup(weights)
        
        var magnitudesResult: [Float] = []
        
        // return first 50 magnitudes
        for i in 0..<input.count / 2 {
            magnitudesResult.append(magnitudes[i])
        }
        
        // set first magnitude to 0 so linear offset does not show
        magnitudesResult[0] = 0
        
        return magnitudesResult
    //    return normalizedMagnitudes
    }
}
