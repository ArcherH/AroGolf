//
//  RecordingButton.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/13/23.
//

import Foundation
import SwiftUI

struct RecordingButton: View {
    
    @Binding var isRecording: Bool
    
    var body: some View {
        // Start Recording button
        Button(action: {
            isRecording.toggle()
        }) {
            Text(isRecording ? "Stop Recording" : "Start Recording")
                .padding()
                .frame(maxWidth: .infinity)
                .background(isRecording ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}
