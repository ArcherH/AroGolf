//
//  SwingView.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import SwiftUI

struct SwingView: View {
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                HStack {
                    Image(systemName: "xmark") // Represents the 'X' button
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Spacer()
                    Text("Sand Wedge")
                        .fontWeight(.bold)
                        .font(.headline)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16))
                }
                .padding()
                
                HStack {
                    Text("Metric Layout")
                    Spacer()
                    Text("Session")
                    Spacer()
                    Text("Swing Count")
                    Spacer()
                    Text("2")
                        .fontWeight(.bold)
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding([.leading, .trailing])
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Spacer()
            
            Text("Training")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 10) {
                Divider()
                    .background(Color.green)
                    .frame(width: 200, height: 3)
                Divider()
                    .background(Color.gray)
                    .frame(width: 200, height: 3)
                Divider()
                    .background(Color.gray)
                    .frame(width: 200, height: 3)
            }
            .padding(.top, 50)
            
            VStack(spacing: 30) {
                HStack {
                    Text("Backswing Time")
                        .fontWeight(.bold)
                    Spacer()
                    Text(".62")
                        .font(.largeTitle)
                    Text("Sec")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Downswing Time")
                        .fontWeight(.bold)
                    Spacer()
                    Text(".32")
                        .font(.largeTitle)
                    Text("Sec")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Swing Tempo")
                        .fontWeight(.bold)
                    Spacer()
                    Text("2.0:1")
                        .font(.largeTitle)
                }
            }
            .padding([.leading, .trailing])
            
            Spacer()
            
            Button(action: {}) {
                Text("Update Goal")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding([.leading, .trailing, .bottom])
        }
    }
}

struct GolfSwingView_Previews: PreviewProvider {
    static var previews: some View {
        SwingView()
    }
}
