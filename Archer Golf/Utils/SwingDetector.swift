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

@Observable
class SwingDetector: SwingDetectorProtocol {
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
    // TODO: Not sure about having this on the main thread
    @ObservationIgnored private var timer: Timer.TimerPublisher
    private var timerSubscription: Cancellable?
    @ObservationIgnored private var sensorDevice: SwingSensorDevice
    @ObservationIgnored private var swingSession: SwingSession
    var currentVelocity: Double
    var isDetecting: Bool = false
        
    init(sensorDevice: SwingSensorDevice, session: SwingSession) {
        self.sensorDevice = sensorDevice
        self.swingSession = session
        self.currentVelocity = 1.0
        let myDispatchQueue = DispatchQueue(label: "Detection buffer")
        timer = Timer.publish(every: deltaTime, on: .main, in: .common)
//            .autoconnect()
//            .receive(subscriber: )
        //setDetectingState(to: false)
        //self.context = ModelContext(container)
        // Subscribe to sensorDevice's observable properties to update slidingWindow
    }
    
    deinit {
        timerSubscription?.cancel()
    }
    
    func setDetectingState(to state: Bool) {
        if state {
            print("Starting timer")
            isDetecting = true

            self.timerSubscription = timer
                .autoconnect()
                .receive(on: RunLoop.main)
                .sink { [weak self] _ in
                    self?.addToSlidingWindow()
                }
        } else {
            print("Stopping timer")
            isDetecting = false
            self.timerSubscription?.cancel()
        }
    }
    
    @objc private func addToSlidingWindow() {
        swingSession.accelX.append(sensorDevice.accelX)
        swingSession.accelY.append(sensorDevice.accelY)
        swingSession.accelZ.append(sensorDevice.accelZ)
        
        swingSession.gyroX.append(sensorDevice.gyroX)
        swingSession.gyroY.append(sensorDevice.gyroY)
        swingSession.gyroZ.append(sensorDevice.gyroZ)
        
        print("adding to window")
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
