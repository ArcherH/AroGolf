//
//  SwingDetector.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/23/23.
//

import Foundation
import SwiftData
import SwiftUI
import Observation

@Observable
class SwingDetector {
//    public let container: ModelContainer = {
//        let config = ModelConfiguration(isStoredInMemoryOnly: false)
//        let container = try! ModelContainer(for: Swing.self, SwingSession.self, configurations: config)
//        return container
//    }()
    
    //var context: ModelContext
    @ObservationIgnored private var slidingWindow: [(accelData: [String: Double], gyroData: [String: Double])] = []
    @ObservationIgnored private let windowSize = 1000
    @ObservationIgnored private let accelThreshold = 10.0
    @ObservationIgnored private let gyroThreshold = 200.0
    @ObservationIgnored private var maxVelocity = 0.0
    @ObservationIgnored private var deltaTime: Double = 0.1
    @ObservationIgnored private var timer: Timer? = nil
    @ObservationIgnored private var sensorDevice: SwingSensorDevice
    @ObservationIgnored private var swingSession: SwingSession
    @ObservationIgnored private var isRecording = false
    
    var currentVelocity: Double
    
    init(sensorDevice: SwingSensorDevice, session: SwingSession) {
        self.sensorDevice = sensorDevice
        self.swingSession = session
        self.currentVelocity = 1.0
        //self.context = ModelContext(container)
        // Subscribe to sensorDevice's observable properties to update slidingWindow
        // self.timer = Timer.scheduledTimer(timeInterval: deltaTime, target: self, selector: #selector(addToSlidingWindow), userInfo: nil, repeats: true)
    }
    
    func toggleRecording() {
        if isRecording == false {
            self.timer = Timer.scheduledTimer(timeInterval: deltaTime, target: self, selector: #selector(addToSlidingWindow), userInfo: nil, repeats: true)
        } else {
            self.timer?.invalidate()
        }
    }

    @objc private func addToSlidingWindow() {
        guard sensorDevice.isConnected else {
            return
        }
        
        let accelData = ["x": sensorDevice.accelX, "y": sensorDevice.accelY, "z": sensorDevice.accelZ]
        let gyroData = ["x": sensorDevice.gyroX, "y": sensorDevice.gyroY, "z": sensorDevice.gyroZ]
        
        let accelerationMagnitude = sqrt(pow(sensorDevice.accelX, 2) + pow(sensorDevice.accelY, 2) + pow(sensorDevice.accelZ, 2))
        self.currentVelocity += accelerationMagnitude * deltaTime
        maxVelocity = max(maxVelocity, currentVelocity)
        
        slidingWindow.append((accelData, gyroData))
        
        if slidingWindow.count > windowSize {
            slidingWindow.removeFirst()
        }
        
        detectSwing()
    }

    private func detectSwing() {
        let meanAccelX = mean(of: "x", from: slidingWindow.map { $0.accelData })
        let meanAccelY = mean(of: "y", from: slidingWindow.map { $0.accelData })
        let meanAccelZ = mean(of: "z", from: slidingWindow.map { $0.accelData })

        let meanGyroX = mean(of: "x", from: slidingWindow.map { $0.gyroData })
        let meanGyroY = mean(of: "y", from: slidingWindow.map { $0.gyroData })
        let meanGyroZ = mean(of: "z", from: slidingWindow.map { $0.gyroData })

        if meanAccelX > accelThreshold && meanGyroX > gyroThreshold &&
           meanAccelY > accelThreshold && meanGyroY > gyroThreshold &&
           meanAccelZ > accelThreshold && meanGyroZ > gyroThreshold {
            //let swing = Swing(faceAngle: 1.9, swingSpeed: maxVelocity, swingPath: 0.1, backSwingTime: 1.0, downSwingTime: 0.5)
            //swingSession.swings.append(swing)
            //try? context.save()
            resetForNewSwing()
        }
    }
    
    private func mean(of axis: String, from data: [[String: Double]]) -> Double {
        return data.map { $0[axis]! }.reduce(0, +) / Double(data.count)
    }
    
    func resetForNewSwing() {
        currentVelocity = 0.0
        maxVelocity = 0.0
    }
}
