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
import Observation

struct SwingStatsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    
    var swingSensor: SwingSensorDevice
    var session: SwingSession
    var swingDetector: SwingDetector
    @State private var displayedSwing: Swing? = nil
    @State private var isRecording: Bool = false
    
    init(swingSensor: SwingSensorDevice, session: SwingSession = SwingSession()) {
        self.session = session
        self.swingSensor = swingSensor
        self.swingDetector = SwingDetector(sensorDevice: swingSensor, session: session)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                Text("Accel: \(swingSensor.accelX.twoDecimals()), \(swingSensor.accelY.twoDecimals()), \(swingSensor.accelZ.twoDecimals())")
                Text("Gyro: \(swingSensor.gyroX.twoDecimals()), \(swingSensor.gyroY.twoDecimals()), \(swingSensor.gyroZ.twoDecimals())")
                Text("isRecording: \(String(swingDetector.isDetecting))")
                Text("Velocity: \(swingDetector.currentVelocity)")
                
                
                // Start Recording button
                Button(action: {
                    isRecording.toggle()
                    swingDetector.setDetectingState(to: isRecording)
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .frame(width: geometry.size.width - 20)
                        .background(isRecording ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                .padding([.bottom], 12)
                
                SwingStatGridView(swing: displayedSwing)
                
                //            Divider()
                //                .frame(width: 340)
                //                .padding([.leading, .trailing], 8)
                
                List {
                    Section(header: Text("Swings")
                        .font(.custom("BR Firma Medium", size: 25))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .textCase(.none)) {
                            ForEach(session.swings.sorted(by: { $0.date < $1.date }), id: \.id) { swing in
                                HStack {
                                    Text(String(swing.downSwingTime.twoDecimals()))
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    displayedSwing = swing
                                }
                            }
                        }
                }
                SwingChart(session: session)
                .overlay(Group {
                    if session.swings.isEmpty {
                        Text("Oops, looks like there's no data...")
                    }
                })
            }
            
            .onAppear {
                let swing = Swing(faceAngle: Double.random(in: 0...3), swingSpeed: Double.random(in: 0...100), swingPath: 1.0, backSwingTime: Double.random(in: 0...3), downSwingTime: Double.random(in: 0...3))
                session.swings.append(swing)
                context.insert(swing)
                context.insert(session)
            }
            .onDisappear{
                swingDetector.setDetectingState(to: false)
            }
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Swing.self, SwingSession.self, configurations: config)
        
        let exampleSwing = Swing(faceAngle: 0.0, swingSpeed: 1.2, swingPath: 2.2, backSwingTime: 1.1, downSwingTime: 0.7)
        var exampleSession = SwingSession()
        
        exampleSession.swings.append(exampleSwing)
        
        return SwingStatsView(swingSensor: MockSwingSensor())
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
