//
//  ContentView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 6/12/23.
//

import SwiftUI

struct ContentView: View {
    var bleManager = BLESwingSensor()
        
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Circle()
                        .fill(bleManager.isConnected ? Color.green : Color.red)
                        .frame(width: 20, height: 20)
                    Text(bleManager.peripheral?.name ?? "No Device Connected")
                }
                
                Text("Accelerometer Data")
                Text("X: \(bleManager.accelX)")
                Text("Y: \(bleManager.accelY)")
                Text("Z: \(bleManager.accelZ)")
                
                Divider()
                
                Text("Gyroscope Data")
                Text("X: \(bleManager.gyroX)")
                Text("Y: \(bleManager.gyroY)")
                Text("Z: \(bleManager.gyroZ)")

                NavigationLink(destination: SwingView()) {
                    Text("Go to Golf Swing View")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding([.top], 20)
                
                List(bleManager.devices) { device in
                    Text(device.name ?? "Unknown Device")
                }
                
            }
            .font(.title2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
