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

    // Sine wave properties
    private let frequency: Double = 1.0 // Frequency of the sine wave
    private let phaseShift: Double = Double.pi / 2 // Phase shift for variety
    private let amplitude: Double = 2.0 // Amplitude to scale the sine wave

    var accelX: Double { amplitude * sin(angle) + amplitude }
    var accelY: Double { amplitude * sin(angle) + amplitude }
    var accelZ: Double { amplitude * sin(angle) + amplitude  }

    var gyroX: Double { amplitude * sin(angle) + amplitude  }
    var gyroY: Double { amplitude * sin(angle) + amplitude  }
    var gyroZ: Double { amplitude * sin(angle) + amplitude  }
    
    var extAccelX: Double { amplitude * sin(angle) + amplitude }
    var extAccelY: Double { amplitude * sin(angle) + amplitude }
    var extAccelZ: Double { amplitude * sin(angle) + amplitude  }

    var extGyroX: Double { amplitude * sin(angle) + amplitude  }
    var extGyroY: Double { amplitude * sin(angle) + amplitude  }
    var extGyroZ: Double { amplitude * sin(angle) + amplitude  }

    var isConnected: Bool { true } // Always connected in this mock
    var name: String { "MockSwingSensor" }

    init() {
        // Initialize and start the timer to update angle and produce sine wave outputs
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.angle += self.frequency * 0.1 // Increment angle based on frequency
            if self.angle > 2 * Double.pi { // Reset the angle to avoid overflow
                self.angle -= 2 * Double.pi
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
