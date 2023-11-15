//
//  SwingSensorDevice.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import Foundation
import Dependencies

protocol SwingSensorDevice: Observable {
    var accelX: Double { get }
    var accelY: Double { get }
    var accelZ: Double { get }
    var gyroX: Double { get }
    var gyroY: Double { get }
    var gyroZ: Double { get }
    var isConnected: Bool { get }
    var name: String { get }
}

private enum SwingSensorKey: DependencyKey {
    static var liveValue: any SwingSensorDevice = BLESwingSensor()
    static var previewValue: any SwingSensorDevice = MockSwingSensor()
}

extension DependencyValues {
  var swingSensor: SwingSensorDevice {
    get { self[SwingSensorKey.self] }
    set { self[SwingSensorKey.self] = newValue }
  }
}
