//
//  SwingSensorDevice.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import Foundation


protocol SwingSensorDevice: Observable {
    var accelX: Double { get }
    var accelY: Double { get }
    var accelZ: Double { get }
    var gyroX: Double { get }
    var gyroY: Double { get }
    var gyroZ: Double { get }
    var isConnected: Bool { get }
    var name: String { get }
}

