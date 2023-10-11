//
//  MockSwingSensor.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/5/23.
//

import Foundation

@Observable
class MockSwingSensor: SwingSensorDevice {
    private var angle: Double = 0.0
    
    // Timer to update values
    private var timer: Timer?
    
    var accelX: Double { angle }
    var accelY: Double { angle }  // Phase shifted for variety
    var accelZ: Double { angle }  // Phase shifted for variety
    
    var gyroX: Double { angle }   // Phase shifted for variety
    var gyroY: Double { angle }   // Phase shifted for variety
    var gyroZ: Double { angle }   // Phase shifted for variety
    
    var isConnected: Bool { true } // Always connected in this mock
    var name: String { "MockSwingSensor" }
    
    init() {
        // Initialize and start the timer to update angle and produce sine wave outputs
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.angle += 1.0
            if self?.angle ?? 0 > 360 {
                self?.angle = 0.0
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
