//
//  SwingSession.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/11/23.
//

import Foundation
import SwiftData

@Model
class SwingSession {
    var date: Date
    
    var gyroX: [Double]
    var gyroY: [Double]
    var gyroZ: [Double]
    
    var accelX: [Double]
    var accelY: [Double]
    var accelZ: [Double]
    
    @Relationship
    var swings: [Swing]
    
    init() {
        self.date = Date()
        
        self.gyroX = []
        self.gyroY = []
        self.gyroZ = []
        self.accelX = []
        self.accelY = []
        self.accelZ = []
        
        self.swings = []
    }
}
