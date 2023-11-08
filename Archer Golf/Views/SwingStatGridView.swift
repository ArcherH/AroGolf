//
//  SwingStatGridView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/30/23.
//

import Foundation
import SwiftUI

struct SwingStatGridView: View {
    var swing: Swing?
    
    var body: some View {
        // Grid of stats
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
