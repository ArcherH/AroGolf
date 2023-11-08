//
//  DoubleUtils.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/12/23.
//

import Foundation

extension Double {

    func truncate(to places: Int = 2) -> Double {
        return Double(Int((pow(10, Double(places)) * self).rounded())) / pow(10, Double(places))
    }

}
