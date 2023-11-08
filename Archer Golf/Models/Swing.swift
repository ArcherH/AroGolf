//
//  Swing.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/11/23.
//

import Foundation
import SwiftData

@Model
class Swing {
    var date: Date
    var faceAngle: Double
    var swingSpeed: Double
    var swingPath: Double
    var backSwingTime: Double
    var downSwingTime: Double
    
    init(faceAngle: Double, swingSpeed: Double, swingPath: Double, backSwingTime: Double, downSwingTime: Double) {
        self.date = Date()
        self.faceAngle = faceAngle
        self.swingSpeed = swingSpeed
        self.swingPath = swingPath
        self.backSwingTime = backSwingTime
        self.downSwingTime = downSwingTime
    }
}
