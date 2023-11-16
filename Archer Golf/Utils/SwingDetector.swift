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
import Combine
import OSLog
import Dependencies

@Observable
public class SwingDetector: SwingDetectorProtocol {
    @ObservationIgnored private var slidingWindow: [(accelData: [String: Double], gyroData: [String: Double])] = []
    @ObservationIgnored private let windowSize = 1000
    @ObservationIgnored private let accelThreshold = 4.0
    @ObservationIgnored private let gyroThreshold = 2.0
    @ObservationIgnored private var maxVelocity = 0.0
    @ObservationIgnored private var deltaTime: Double = 0.0005
    // TODO: Not sure about having this on the main thread
    @ObservationIgnored private var timer: Timer.TimerPublisher
    @ObservationIgnored private var timerSubscription: Cancellable?
    
    @ObservationIgnored @Dependency(\.swingSensor) var swingSensor
    
    private let swingSubject = PassthroughSubject<Swing, Never>()
    
    var swingPublisher: AnyPublisher<Swing, Never> {
        swingSubject.eraseToAnyPublisher()
    }
    
    // Observed Properties
    var currentVelocity: Double
    var isDetecting: Bool
        
    init() {
        self.currentVelocity = 0.0
        self.isDetecting = false
        timer = Timer.publish(every: deltaTime, on: .main, in: .common)
    }
    
    deinit {
        timerSubscription?.cancel()
    }
    
    func setDetectingState(to state: Bool) {
        if state {
            Logger.swingDetection.info("Starting detection timer")
            isDetecting = true

            self.timerSubscription = timer
                .autoconnect()
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.addToSlidingWindow()
                }
        } else {
            Logger.swingDetection.info("Stopping detection timer")
            isDetecting = false
            self.timerSubscription?.cancel()
        }
    }
    
    @objc private func addToSlidingWindow() {
        
        guard swingSensor.isConnected else {
            return
        }
        
        // Logger.swingDetection.info("adding sensor reading to sliding window")
        let accelData = ["x": swingSensor.accelX, "y": swingSensor.accelY, "z": swingSensor.accelZ]
        let gyroData = ["x": swingSensor.gyroX, "y": swingSensor.gyroY, "z": swingSensor.gyroZ]
        
        let accelerationMagnitude = sqrt(pow(swingSensor.accelX, 2) + pow(swingSensor.accelY, 2) + pow(swingSensor.accelZ, 2))
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
            
            let swing = Swing(faceAngle: 1.9, swingSpeed: maxVelocity, swingPath: 0.1, backSwingTime: 1.0, downSwingTime: 0.5)
            Logger.swingDetection.info("Swing Detected")
            swingSubject.send(swing)
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
