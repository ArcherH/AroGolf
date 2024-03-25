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
    var numRows: CGFloat = 3
    var numColums: CGFloat = 2
    var horizontalSpacing: CGFloat = 20
    var verticalSpacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                
                Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                
                    
                    GridRow {
                        RoundedRectangleWithShadow(title: "Face Angle",
                                                   stat: (swing?.faceAngle != nil) ? "\(swing!.faceAngle.truncate())°": "-",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                        
                        RoundedRectangleWithShadow(title: "Swing Speed",
                                                   stat: (swing?.swingSpeed != nil) ? "\(swing!.swingSpeed.truncate(to: 1))" : "-",
                                                   unit: "mph",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                    }
                    
                    GridRow {
                        RoundedRectangleWithShadow(title: "Swing Path",
                                                   stat: (swing?.swingPath != nil) ? "\(swing!.swingPath.truncate())" : "-",
                                                   unit: "in",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                        
                        RoundedRectangleWithShadow(title: "Tempo",
                                                   stat: (swing?.backSwingTime != nil && swing?.downSwingTime != nil) ? "\((swing!.backSwingTime / swing!.downSwingTime).truncate()) : 1" : "-",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                    }
                    
                    GridRow {
                        RoundedRectangleWithShadow(title: "Back Swing Time",
                                                   stat: (swing?.backSwingTime != nil) ? "\(swing!.backSwingTime.truncate())" : "-",
                                                   unit: "sec",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                        
                        RoundedRectangleWithShadow(title: "Down Swing Time",
                                                   stat: (swing?.downSwingTime != nil) ? "\(swing!.downSwingTime.truncate())" : "-",
                                                   unit: "sec",
                                                   width: (geometry.size.width / numColums) - horizontalSpacing,
                                                   height: geometry.size.height / numRows - verticalSpacing)
                    }
                }
                
                Spacer()
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
