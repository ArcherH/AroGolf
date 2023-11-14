//
//  Logger.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/13/23.
//

import Foundation
import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let swingDetection = Logger(subsystem: subsystem, category: "swing detection")

    /// All logs related to tracking and analytics.
    static let swingView = Logger(subsystem: subsystem, category: "swing view")
}
