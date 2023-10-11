//
//  SumGyro.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/6/23.
//

import Foundation

@Observable
class SumGyro {
    private var delay = 0.1
    private var sensor: SwingSensorDevice
    private var timer: Timer?
    var totalX = 0.0
    var totalY = 0.0
    var totalZ = 0.0
    var lastUpdateDate = Date()
    
    init(sensor: SwingSensorDevice) {
        self.sensor = sensor
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGyro), userInfo: nil, repeats: true)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func updateGyro() {
        totalX += sensor.gyroX * delay
        totalY += sensor.gyroY * delay
        totalZ += sensor.gyroZ * delay
    }
}
