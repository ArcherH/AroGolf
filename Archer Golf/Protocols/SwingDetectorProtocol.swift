//
//  SwingDetectorProtocol.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/10/23.
//

import Foundation
import Dependencies
import Combine

protocol SwingDetectorProtocol: Observable {
    var currentVelocity: Double { get set }
    var isDetecting: Bool { get set }
    var swingPublisher: AnyPublisher<Swing, Never> { get }
    var velocityThreshold: Double { get set }
    func setDetectingState(to state: Bool)
}

private enum SwingDetectorKey: DependencyKey {
    static var liveValue: any SwingDetectorProtocol = SwingDetector()
    static var previewValue: any SwingDetectorProtocol = SwingDetector()
}

extension DependencyValues {
  var swingDetector: SwingDetectorProtocol {
    get { self[SwingDetectorKey.self] }
    set { self[SwingDetectorKey.self] = newValue }
  }
}
