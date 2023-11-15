//
//  AppHeader.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/30/23.
//

import SwiftUI
import Dependencies

struct AppHeader: View {
    @Dependency(\.swingSensor) var swingSensor
    
    var body: some View {
        HStack {
            Image(systemName: "gear")
                .foregroundStyle(Color.blue)
                .padding([.leading])
            
            Spacer()
            
            Text("Aro Golf")
                .font(.custom("BR Firma Black", size: 34))
            
            
            Spacer()
            
            Image(systemName: !swingSensor.isConnected ? "point.3.connected.trianglepath.dotted" : "point.3.filled.connected.trianglepath.dotted")
                .foregroundStyle(swingSensor.isConnected ? Color.green : Color.red)
                .frame(width: 15, height: 15)
                .padding([.trailing])
        }
    }
}

#Preview {
    AppHeader()
}
