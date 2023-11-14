//
//  SwingDetectorProtocol.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 11/10/23.
//

import Foundation

protocol SwingDetectorProtocol: Observable {
    var currentVelocity: Double { get set }
    var isDetecting: Bool { get set }
    
    func setDetectingState(to state: Bool)
}
