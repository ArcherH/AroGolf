//
//  DoubleUtils.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/12/23.
//

import Foundation

extension Double {

    func truncate(to places: Int = 2) -> Double {
        if self != 0.0 && !self.isNaN {
            return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
        } else {
            return 0.0
        }
    }
    
    func twoDecimals() -> String {
        return self.formatted(.number.precision(.fractionLength(2)))
    }

}
