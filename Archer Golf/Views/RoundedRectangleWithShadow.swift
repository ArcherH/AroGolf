//
//  RoundedRectangleWithShadow.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/12/23.
//

import Foundation
import SwiftUI

struct RoundedRectangleWithShadow: View {
    var title: String
    var stat: String
    var unit: String?
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.5))
                .frame(width: width, height: height)
            
            
            VStack {
                Text(title)
                    .foregroundStyle(.blue)
                    .minimumScaleFactor(0.5)
                HStack {
                    Text(stat)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    if let unit {
                        Text(unit)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                
            }
        }
    }
}

#Preview {
    RoundedRectangleWithShadow(title: "Test Stat with long title", stat: "100.0", unit: "mph", width: 300, height: 200)
}
