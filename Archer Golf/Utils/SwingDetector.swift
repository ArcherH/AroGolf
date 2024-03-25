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

/// This implementation of the swing detector protocol detects golf swing events from a SwingSensorDevice
/// Every deltaTime, the addToSlidingWindow function is called, which updates a buffer of sensor readings and detects whether
/// a swing occured. If it occurs, then the swing metrics are recorded and a new Swing sent through the swingSubject
@Observable public class SwingDetector: SwingDetectorProtocol {
    @ObservationIgnored private var slidingWindow: SlidingWindow
    @ObservationIgnored var gyroThreshold = 1.0
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
    var velocityThreshold: Double = 1.0
        
    init() {
        self.currentVelocity = 0.0
        self.isDetecting = false
        timer = Timer.publish(every: deltaTime, on: .main, in: .common)
        self.slidingWindow = SlidingWindow()
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
    
    /// This function is called by the ``timerSubscription`` every ``deltaTime`` seconds.
    /// It maintains a buffer of the last ``windowSize`` sensor readings that are used in ``detectSwing``
    /// to determine whether a swing has occured. This approach is probably too naive for robust detection of swings,
    /// but it provides a starting point for calculating velocity at the very least.
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

        slidingWindow.addAccelReading(x: accelData["x"]!, y: accelData["y"]!, z: accelData["z"]!)
        slidingWindow.addGyroReading(x: accelData["x"]!, y: accelData["y"]!, z: accelData["z"]!)
        detectSwing()
    }

    private func detectSwing() {
        let velocityThresholdMph = velocityThreshold * 2.23694  // Convert threshold to mph
        
        if currentVelocity > 1 {
            let swing = Swing(faceAngle: 1.9, swingSpeed: maxVelocity, swingPath: 0.1, backSwingTime: 1.0, downSwingTime: 0.5)
            
            swing.accelX = slidingWindow.accelXValues
            swing.accelY = slidingWindow.accelYValues
            swing.accelZ = slidingWindow.accelZValues
            
            swing.gyroX = slidingWindow.gyroXValues
            swing.gyroY = slidingWindow.gyroYValues
            swing.gyroZ = slidingWindow.gyroZValues
            
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


struct SlidingWindow {
    let maxNumberOfReadings = 100
    var accelXValues: [Double] = []
    var accelYValues: [Double] = []
    var accelZValues: [Double] = []
    
    var gyroXValues: [Double] = []
    var gyroYValues: [Double] = []
    var gyroZValues: [Double] = []
    
    mutating func addAccelReading(x: Double, y: Double, z: Double) {
        accelXValues.append(x)
        accelYValues.append(y)
        accelZValues.append(z)
        
        if accelXValues.count > maxNumberOfReadings {
            accelXValues.removeFirst()
        }
        if accelYValues.count > maxNumberOfReadings {
            accelYValues.removeFirst()
        }
        if accelZValues.count > maxNumberOfReadings {
            accelZValues.removeFirst()
        }
    }
    
    mutating func addGyroReading(x: Double, y: Double, z: Double) {
        gyroXValues.append(x)
        gyroYValues.append(y)
        gyroZValues.append(z)
        
        if gyroXValues.count > maxNumberOfReadings {
            gyroXValues.removeFirst()
        }
        if gyroYValues.count > maxNumberOfReadings {
            gyroYValues.removeFirst()
        }
        if gyroZValues.count > maxNumberOfReadings {
            gyroZValues.removeFirst()
        }
    }
}
