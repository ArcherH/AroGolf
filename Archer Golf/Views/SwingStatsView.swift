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
import Combine

struct SwingStatsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @Dependency(\.swingSensor) var swingSensor
    @Dependency(\.swingDetector) var swingDetector
    
    //var swingSensor: SwingSensorDevice
    @State var session: SwingSession = SwingSession()
    @State private var displayedSwing: Swing?
    @State private var isRecording: Bool
    @State private var showSheet: Bool
    @State var swingSubscription: AnyCancellable?
    private var isNewSession: Bool = true
    
    init(session: SwingSession) {
        isNewSession = false
        _session = State(initialValue: session)
        _displayedSwing = State(initialValue: session.swings.first)
        _isRecording = State(initialValue: false)
        _showSheet = State(initialValue: false)
        _swingSubscription = State(initialValue: nil)
    }
    
    init() {
        _displayedSwing = State(initialValue: nil)
        _isRecording = State(initialValue: false)
        _showSheet = State(initialValue: false)
        _swingSubscription = State(initialValue: nil)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    SensorStats()

                    Text((swingDetector.currentVelocity  * 2.23694).twoDecimals())
                    
                    RecordButton(isRecording: $isRecording,
                                 animation: .default,
                                 buttonColor: .red,
                                 borderColor: .white,
                                 startAction: {swingDetector.setDetectingState(to: true)},
                                 stopAction: {swingDetector.setDetectingState(to: false)}
                    )
                    .padding([.bottom], 12)
                    .frame(width: geometry.size.width / 7, height: geometry.size.width / 7)
                }
                
                SwingStatGridView(swing: displayedSwing)
                    .frame(alignment: .center)
                
                SwingListView(displayedSwing: $displayedSwing, session: $session)
                
                Button("Sensor Graph") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    SwingChart(session: session)
                }
                
            }
            .onAppear {
                if isNewSession {
                    context.insert(session)
                }
                
                swingSubscription = subscribeToSwingPublisher()
            }
            .onDisappear{
                swingDetector.setDetectingState(to: false)
            }
        }
    }
    
    private func subscribeToSwingPublisher() -> AnyCancellable {
        return swingDetector.swingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [self] swing in
                context.insert(swing)
                session.swings.append(swing)
                try? context.save()
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
        
        return SwingStatsView(session: exampleSession)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
