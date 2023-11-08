//
//  SwingDetector.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/23/23.
//

import Foundation

class SwingDetector {
    var slidingWindow: [(accelData: [String: Double], gyroData: [String: Double])] = []
    let windowSize = 1000
    let accelThreshold = 10.0
    let gyroThreshold = 200.0
    var sensorDevice: SwingSensorDevice
    
    init(sensorDevice: SwingSensorDevice) {
        self.sensorDevice = sensorDevice
        // Subscribe to sensorDevice's observable properties to update slidingWindow
    }

    func addToSlidingWindow() async -> Bool {
        guard sensorDevice.isConnected else {
            return false
        }
        
        let accelData = ["x": sensorDevice.accelX, "y": sensorDevice.accelY, "z": sensorDevice.accelZ]
        let gyroData = ["x": sensorDevice.gyroX, "y": sensorDevice.gyroY, "z": sensorDevice.gyroZ]
        
        slidingWindow.append((accelData, gyroData))
        
        if slidingWindow.count > windowSize {
            slidingWindow.removeFirst()
        }
        
        return await detectSwing()
    }

    private func detectSwing() async -> Bool {
        let meanAccelX = mean(of: "x", from: slidingWindow.map { $0.accelData })
        let meanAccelY = mean(of: "y", from: slidingWindow.map { $0.accelData })
        let meanAccelZ = mean(of: "z", from: slidingWindow.map { $0.accelData })

        let meanGyroX = mean(of: "x", from: slidingWindow.map { $0.gyroData })
        let meanGyroY = mean(of: "y", from: slidingWindow.map { $0.gyroData })
        let meanGyroZ = mean(of: "z", from: slidingWindow.map { $0.gyroData })

        if meanAccelX > accelThreshold && meanGyroX > gyroThreshold &&
           meanAccelY > accelThreshold && meanGyroY > gyroThreshold &&
           meanAccelZ > accelThreshold && meanGyroZ > gyroThreshold {
            return true
        }

        return false
    }
    
    private func mean(of axis: String, from data: [[String: Double]]) -> Double {
        return data.map { $0[axis]! }.reduce(0, +) / Double(data.count)
    }
}
