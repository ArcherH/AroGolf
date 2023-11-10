//
//  Archer_GolfApp.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import SwiftUI
import SwiftData

@main
struct Archer_GolfApp: App {
        
    init() {
        UIFont.overrideInitialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Swing.self, SwingSession.self])
    }
}
