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
    
    let modelContainer: ModelContainer
        
    init() {
        UIFont.overrideInitialize() 
        do {
            modelContainer = try ModelContainer(for: Swing.self, SwingSession.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.modelContainer(for: [Swing.self, SwingSession.self], isUndoEnabled: true)
    }
}
