//
//  SwingChart.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/10/23.
//

import SwiftUI
import Charts
import SwiftData

struct SwingChart: View {
    var session: SwingSession
    
    var body: some View {
        
        Chart {
            ForEach(Array(session.accelX.enumerated()), id: \.offset) { index, accelx in
                LineMark(
                    x: .value("time", index),
                    y: .value("Deg/s", accelx)
                )
            }
            
//            ForEach(Array(session.accelY.enumerated()), id: \.offset) { index, accelx in
//                LineMark(
//                    x: .value("time", index),
//                    y: .value("Deg/s", accelx)
//                )
//            }
        }
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Swing.self, SwingSession.self, configurations: config)
        
        let exampleSwing = Swing(faceAngle: 0.0, swingSpeed: 1.2, swingPath: 2.2, backSwingTime: 1.1, downSwingTime: 0.7)
        var exampleSession = SwingSession()
        exampleSession.accelX = [0.2, 0.1, 0.3]
        
        exampleSession.swings.append(exampleSwing)
        
        return SwingChart(session: exampleSession)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
