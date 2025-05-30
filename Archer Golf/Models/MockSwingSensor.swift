//
//  MockSwingSensor.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/5/23.
//

import Foundation

@Observable
class MockSwingSensor: SwingSensorDevice {
    // Swing simulation properties
    private enum SwingPhase {
        case idle, backswing, downswing, impact, followThrough
    }
    private var phase: SwingPhase = .idle
    private var phaseTime: Double = 0.0
    private var swingTimer: Timer?
    private let swingIntervalRange: ClosedRange<Double> = 2.0...5.0 // seconds between swings
    private let dt: Double = 0.02 // 50Hz update rate
    private var timer: Timer?

    // Simulated sensor values
    private var _accelX: Double = 0.0
    private var _accelY: Double = 0.0
    private var _accelZ: Double = 0.0
    private var _gyroX: Double = 0.0
    private var _gyroY: Double = 0.0
    private var _gyroZ: Double = 0.0

    var accelX: Double { _accelX }
    var accelY: Double { _accelY }
    var accelZ: Double { _accelZ }
    var gyroX: Double { _gyroX }
    var gyroY: Double { _gyroY }
    var gyroZ: Double { _gyroZ }
    var extAccelX: Double { _accelX }
    var extAccelY: Double { _accelY }
    var extAccelZ: Double { _accelZ }
    var extGyroX: Double { _gyroX }
    var extGyroY: Double { _gyroY }
    var extGyroZ: Double { _gyroZ }

    var isConnected: Bool { true } // Always connected in this mock
    var name: String { "MockSwingSensor" }

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: dt, repeats: true) { [weak self] _ in
            self?.updateSensorValues()
        }
        scheduleNextSwing()
    }

    private func scheduleNextSwing() {
        let delay = Double.random(in: swingIntervalRange)
        swingTimer?.invalidate()
        swingTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.startSwing()
        }
    }

    private func startSwing() {
        phase = .backswing
        phaseTime = 0.0
    }

    private func updateSensorValues() {
        switch phase {
        case .idle:
            setSensorValues(ax: 0, ay: 0, az: 9.8, gx: 0, gy: 0, gz: 0, noise: 0.2)
        case .backswing:
            let t = phaseTime
            setSensorValues(
                ax: -3.0 * sin(t * .pi),
                ay: 1.0 * sin(t * .pi / 2),
                az: 9.8 + 0.5 * cos(t * .pi),
                gx: 120 * sin(t * .pi),
                gy: 60 * sin(t * .pi / 2),
                gz: 10 * sin(t * .pi / 2),
                noise: 0.5
            )
            if phaseTime > 0.4 { phase = .downswing; phaseTime = 0.0 }
        case .downswing:
            let t = phaseTime
            setSensorValues(
                ax: 8.0 * sin(t * .pi),
                ay: -2.0 * sin(t * .pi / 2),
                az: 9.8 + 1.5 * cos(t * .pi),
                gx: 350 * sin(t * .pi),
                gy: 180 * sin(t * .pi / 2),
                gz: 30 * sin(t * .pi / 2),
                noise: 1.0
            )
            if phaseTime > 0.2 { phase = .impact; phaseTime = 0.0 }
        case .impact:
            setSensorValues(
                ax: 20 + Double.random(in: -2...2),
                ay: Double.random(in: -3...3),
                az: 9.8 + Double.random(in: -2...2),
                gx: 800 + Double.random(in: -50...50),
                gy: 400 + Double.random(in: -30...30),
                gz: 100 + Double.random(in: -20...20),
                noise: 2.0
            )
            if phaseTime > 0.04 { phase = .followThrough; phaseTime = 0.0 }
        case .followThrough:
            let decay = exp(-phaseTime * 6)
            setSensorValues(
                ax: 2.0 * decay,
                ay: 1.0 * decay,
                az: 9.8 + 0.2 * decay,
                gx: 80 * decay,
                gy: 40 * decay,
                gz: 10 * decay,
                noise: 0.3
            )
            if decay < 0.05 || phaseTime > 0.5 {
                phase = .idle
                phaseTime = 0.0
                scheduleNextSwing()
            }
        }
        phaseTime += dt
    }

    private func setSensorValues(ax: Double, ay: Double, az: Double, gx: Double, gy: Double, gz: Double, noise: Double) {
        _accelX = ax + Double.random(in: -noise...noise)
        _accelY = ay + Double.random(in: -noise...noise)
        _accelZ = az + Double.random(in: -noise...noise)
        _gyroX = gx + Double.random(in: -noise*10...noise*10)
        _gyroY = gy + Double.random(in: -noise*10...noise*10)
        _gyroZ = gz + Double.random(in: -noise*10...noise*10)
    }

    deinit {
        timer?.invalidate()
        swingTimer?.invalidate()
    }
}
