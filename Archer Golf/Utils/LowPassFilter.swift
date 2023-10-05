//
//  LowPassFilter.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/5/23.
//

import Foundation

class Filters {
    // A smaller alpha will result in more smoothing, while a larger alpha will make the filter respond more quickly to changes.
    static func lowPassFilter(newReading: Double, previousReading: Double, alpha: Double = 0.05) -> Double {
        return newReading * alpha + previousReading * (1.0 - alpha)
    }
}

