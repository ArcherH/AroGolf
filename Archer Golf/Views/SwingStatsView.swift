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
import OSLog
import Dependencies

struct SwingStatsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @Dependency(\.swingSensor) var swingSensor
    
    //var swingSensor: SwingSensorDevice
    var session: SwingSession
    var swingDetector: SwingDetectorProtocol
    @State private var displayedSwing: Swing? = nil
    @State private var isRecording: Bool = false {
        didSet {
            swingDetector.setDetectingState(to: isRecording)
        }
    }
    @State private var showSheet = false
    
    init(session: SwingSession = SwingSession()) {
        self.session = session
        self.swingDetector = SwingDetector(session: session)
        Logger.swingView.info("Initializing SwingStatsView/swingDetector")
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                SensorStats()
                Text("isRecording: \(String(swingDetector.isDetecting))")
                Text("Velocity: \(swingDetector.currentVelocity)")
                
                
                RecordingButton(isRecording: $isRecording)
                    .padding([.bottom], 12)
                
                SwingStatGridView(swing: displayedSwing)
                    .frame(alignment: .center)
                
                SwingListView(displayedSwing: $displayedSwing, session: session)
                
                Button("Sensor Graph") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    SwingChart(session: session)
                }
                
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
        
        return SwingStatsView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
