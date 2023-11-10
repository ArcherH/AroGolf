//
//  ContentView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 6/12/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
#if targetEnvironment(simulator)
    var swingSensor = MockSwingSensor()
#else
    var swingSensor = BLESwingSensor()
#endif
    
    @Environment(\.modelContext) private var context
    @Query var sessions: [SwingSession]
    @State private var showDropdown = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AppHeader(sensor: swingSensor)
                
                HStack {
                    VStack(spacing: 15) {
                        Text("Accel Data")
                        Text("X: \(swingSensor.accelX.twoDecimals())")
                        Text("Y: \(swingSensor.accelY.twoDecimals())")
                        Text("Z: \(swingSensor.accelZ.twoDecimals())")
                    }
                    .padding()
                    
                    Divider()
                        .frame(height: 100)
                    
                    VStack(spacing: 15) {
                        Text("Gyro Data")
                        Text("X: \(swingSensor.gyroX.twoDecimals())")
                        Text("Y: \(swingSensor.gyroY.twoDecimals())")
                        Text("Z: \(swingSensor.gyroZ.twoDecimals())")
                    }
                    .padding()
                }
                
                VStack(spacing: 0) {
//                    RectangleTest(sensor: swingSensor)
//                        .padding()
                    
                    HStack {
                        Text("Sessions")
                            .font(.custom("BR Firma Medium", size: 25))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .font(.title)
                            .padding([.leading])
                        Spacer()
                        NavigationLink(destination: SwingStatsView(swingSensor: swingSensor)) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(.blue)
                                .clipShape(Circle())
                                .frame(width: 10, height: 10)
                                .padding([.trailing])
                        }
                    }
                    
                    
                    List(sessions, id: \.id) { session in
                        NavigationLink {
                            SwingStatsView(swingSensor: swingSensor, session: session)
                        } label: {
                            Text(session.date.description)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Swing.self, SwingSession.self, configurations: config)
            
            return ContentView()
                .modelContainer(container)
        } catch {
            fatalError("Failed to create model container.")
        }
    }
}
