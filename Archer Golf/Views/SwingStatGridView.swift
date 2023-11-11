//
//  SwingStatGridView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/30/23.
//

import Foundation
import SwiftUI
import SwiftData

struct SwingStatGridView: View {
    var swing: Swing?
    
    var body: some View {
        // Grid of stats
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                RoundedRectangleWithShadow(title: "Face Angle",
                                           stat: (swing?.faceAngle != nil) ? "\(swing!.faceAngle.truncate())°": "-")
                
                RoundedRectangleWithShadow(title: "Swing Speed",
                                           stat: (swing?.swingSpeed != nil) ? "\(swing!.swingSpeed.truncate(to: 1))" : "-",
                                           unit: "mph")
            }
            
            HStack(spacing: 15) {
                
                RoundedRectangleWithShadow(title: "Swing Path",
                                           stat: (swing?.swingPath != nil) ? "\(swing!.swingPath.truncate())" : "-",
                                           unit: "in")
                
                RoundedRectangleWithShadow(title: "Tempo",
                                           stat: (swing?.backSwingTime != nil && swing?.downSwingTime != nil) ? "\((swing!.backSwingTime / swing!.downSwingTime).truncate()) : 1" : "-")
            }
            
            HStack(spacing: 15) {
                RoundedRectangleWithShadow(title: "Back Swing Time",
                                           stat: (swing?.backSwingTime != nil) ? "\(swing!.backSwingTime.truncate())" : "-",
                                           unit: "sec")
                
                RoundedRectangleWithShadow(title: "Down Swing Time",
                                           stat: (swing?.downSwingTime != nil) ? "\(swing!.downSwingTime.truncate())" : "-",
                                           unit: "sec")
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
        
        return SwingStatGridView(swing: exampleSwing)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
