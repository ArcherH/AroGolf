//
//  SensorStats.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/13/23.
//

import SwiftUI
import Observation
import Dependencies

struct SensorStats: View {
    @Dependency(\.swingSensor) var swingSensor
    
    var body: some View {
        Text("Accel: \(swingSensor.accelX.twoDecimals()), \(swingSensor.accelY.twoDecimals()), \(swingSensor.accelZ.twoDecimals())")
        Text("Gyro: \(swingSensor.gyroX.twoDecimals()), \(swingSensor.gyroY.twoDecimals()), \(swingSensor.gyroZ.twoDecimals())")
    }
}

#Preview {
    SensorStats()
}
