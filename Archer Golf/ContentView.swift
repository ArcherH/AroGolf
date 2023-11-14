//
//  ContentView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 6/12/23.
//

import SwiftUI
import SwiftData
import Dependencies

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @Dependency(\.swingSensor) var swingSensor
    
    @Query var sessions: [SwingSession]
    @State private var showDropdown = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AppHeader(sensor: swingSensor)
                
                SensorStats()
                
                VStack(spacing: 0) {
//                    RectangleTest(sensor: swingSensor)
//                        .padding()
                    
                    List {
                        Section(header:
                                    HStack {
                            Text("Sessions")
                                .font(.custom("BR Firma Medium", size: 25))
                                .textCase(.none)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            NavigationLink(destination: SwingStatsView()) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(.blue)
                                    .clipShape(Circle())
                                    .frame(width: 10, height: 10)
                                    .padding([.trailing])
                            }
                            .padding()
                        }){
                            ForEach(sessions) { session in
                                NavigationLink {
                                    SwingStatsView(session: session)
                                } label: {
                                    Text(session.date.description)
                                }
                            }
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
