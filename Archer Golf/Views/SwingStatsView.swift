//
//  SwingStatsView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/11/23.
//

import Foundation
import SwiftUI
import Charts
import SwiftData

struct SwingStatsView: View {
    @Environment(\.modelContext) private var context
    var swingSensor: SwingSensorDevice
    
    @State private var displayedSwing: Swing? = nil
    
    @State private var faceAngle: Double? = nil
    @State private var swingSpeed: Double? = nil
    @State private var swingPath: Double? = nil
    @State private var backSwingTime: Double? = nil
    @State private var downSwingTime: Double? = nil
    @State private var isRecording: Bool = false
    
    var session: SwingSession = SwingSession()

    var body: some View {
        VStack(spacing: 15) {
            // Start Recording button
            Text("Accel: \(swingSensor.accelX.truncate()), \(swingSensor.accelY.truncate()), \(swingSensor.accelZ.truncate())")

            Text("Gyro: \(swingSensor.gyroX.truncate()), \(swingSensor.gyroY.truncate()), \(swingSensor.gyroZ.truncate())")
            Button(action: {
                isRecording.toggle()
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .frame(width: 340)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            SwingStatGridView(swing: displayedSwing)
            
            Text("Swings")
                .font(.custom("BR Firma Medium", size: 25))
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top], 8)
            
            
            Divider()
                .frame(width: 340)
                .padding([.leading, .trailing], 8)
            
            List(session.swings.sorted(by: { $0.date < $1.date }), id: \.id) { swing in
                Text(String(swing.downSwingTime))
                    .onTapGesture {
                        displayedSwing = swing
                    }
            }
            .overlay(Group {
                if session.swings.isEmpty {
                    Text("Oops, looks like there's no data...")
                }
            })
        }
        .onAppear {
            let swing = Swing(faceAngle: Double.random(in: 0...3), swingSpeed: Double.random(in: 0...100), swingPath: 1.0, backSwingTime: Double.random(in: 0...3), downSwingTime: Double.random(in: 0...3))
            session.swings.append(swing)
//            context.insert(swing)
//            context.insert(session)
        }
    }
}


#Preview {
    MainActor.assumeIsolated {
        SwingStatsView(swingSensor: MockSwingSensor())
    }
}
