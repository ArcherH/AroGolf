//
//  IMU.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 1/22/24.
//

import Foundation

struct IMU: Identifiable, Observable {
    var id = UUID()
    
    var accelX: Double
    var accelY: Double
    var accelZ: Double
    
    var gyroX: Double
    var gyroY: Double
    var gyroZ: Double
    
    var magX: Double?
    var magY: Double?
    var magZ: Double?
    
    var absoluteOrientation: Quaternion
}
