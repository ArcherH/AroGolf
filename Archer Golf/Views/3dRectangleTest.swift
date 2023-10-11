//
//  3dRectangleTest.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/6/23.
//

import SwiftUI
import Foundation

struct RectangleTest: View {
    var sensor: SwingSensorDevice
    var body: some View {
        
        Rectangle()
            .fill(Color.blue)
            .frame(width: 200, height: 100)
            .rotation3DEffect(
                Angle(degrees: sensor.gyroX),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .rotation3DEffect(
                Angle(degrees: sensor.gyroY),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .rotation3DEffect(
                Angle(degrees: sensor.gyroZ),
                axis: (x: 0.0, y: 0.0, z: 1.0)
            )
            .animation(.spring(response: 0.5, dampingFraction: 0.2, blendDuration: 0))
    }
}

