//
//  AppHeader.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/30/23.
//

import SwiftUI

struct AppHeader: View {
    var sensor: SwingSensorDevice
    
    var body: some View {
        HStack {
            Image(systemName: "gear")
                .foregroundStyle(Color.blue)
                .padding([.leading])
            
            Spacer()
            
            Text("Aro Golf")
                .font(.custom("BR Firma Black", size: 34))
            
            
            Spacer()
            
            Circle()
                .fill(sensor.isConnected ? Color.green : Color.red)
                .frame(width: 15, height: 15)
                .padding([.trailing])
        }
    }
}

#Preview {
    AppHeader(sensor: MockSwingSensor())
}
