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
    @ObservationIgnored private let windowSize = 100
   
    @ObservationIgnored var gyroThreshold = 9.0
    @ObservationIgnored private var maxVelocity = 0.0
    @ObservationIgnored private var deltaTime: Double = 0.001
    // TODO: Not sure about having this on the main thread
    @ObservationIgnored private var timer: Timer.TimerPublisher
    @ObservationIgnored private var timerSubscription: Cancellable?
    
    @ObservationIgnored @Dependency(\.swingSensor) var swingSensor
    
    private let swingSubject = PassthroughSubject<Swing, Never>()
    
    var swingPublisher: AnyPublisher<Swing, Never> {
        swingSubject.eraseToAnyPublisher()
    }
    
    private var velocityX: Double = 0.0
    private var velocityY: Double = 0.0
    private var velocityZ: Double = 0.0
    
    // Observed Properties
    var currentVelocity: Double
    var isDetecting: Bool
    var velocityThreshold: Double = 10.0
        
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

        let accelData = ["x": swingSensor.accelX, "y": swingSensor.accelY, "z": swingSensor.accelZ]
        let gyroData = ["x": swingSensor.gyroX, "y": swingSensor.gyroY, "z": swingSensor.gyroZ]
        
        // Calculate velocity change for each axis
        let velocityChangeX = accelData["x"]! * deltaTime
        let velocityChangeY = accelData["y"]! * deltaTime
        let velocityChangeZ = accelData["z"]! * deltaTime

        // Update velocity for each axis
        self.velocityX += velocityChangeX
        self.velocityY += velocityChangeY
        self.velocityZ += velocityChangeZ

        self.currentVelocity = sqrt(pow(velocityX, 2) + pow(velocityY, 2) + pow(velocityZ, 2))
        // Calculate change in velocity (in m/s)
        // Convert current velocity to mph
           let currentVelocityMph = self.currentVelocity * 2.23694
           maxVelocity = max(maxVelocity, currentVelocityMph)  // Store the max velocity in mph


        slidingWindow.append((accelData, gyroData))

        if slidingWindow.count > windowSize {
            slidingWindow.removeFirst()
        }

        detectSwing()
    }

    private func detectSwing() {
        let velocityThresholdMph = velocityThreshold * 2.23694  // Convert threshold to mph
        if currentVelocity > velocityThresholdMph {
            let swing = Swing(faceAngle: 1.9, swingSpeed: maxVelocity, swingPath: 0.1, backSwingTime: 1.0, downSwingTime: 0.5)
            Logger.swingDetection.info("Swing Detected")
            swingSubject.send(swing)
            resetForNewSwing()
        }
    }
    
    private func mean(of axis: String, from data: [[String: Double]]) -> Double {
        return data.map { $0[axis]! }.reduce(0, +) / Double(data.count)
    }
    
    private func resetForNewSwing() {
        velocityX = 0.0
        velocityY = 0.0
        velocityZ = 0.0
        currentVelocity = 0.0
        maxVelocity = 0.0
    }
}
