//
//  SwingListView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/13/23.
//

import SwiftUI

struct SwingListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var displayedSwing: Swing?
    var session: SwingSession
    
    var body: some View {
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
    }
}

//#Preview {
//    @State var exampleSwing = Swing(faceAngle: 0.0, swingSpeed: 1.2, swingPath: 2.2, backSwingTime: 1.1, downSwingTime: 0.7)
//    SwingListView(displayedSwing: $exampleSwing)
//}
