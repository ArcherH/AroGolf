//
//  UUIDUtils.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import Foundation
import CoreBluetooth

struct Devices {

    static let kBLEService_UUID = "19B10000-E8F2-537E-4F6C-D104768A1214"
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    
    static let accelXCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCEAA"
    static let accelYCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCEBB"
    static let accelZCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCECC"
    
    static let gyroXCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCEDD"
    static let gyroYCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCEEE"
    static let gyroZCharUuid = "19B10001-E8F2-537E-4F6C-D10476ACCEFF"

    static let accelX_UUID = CBUUID(string: accelXCharUuid)
    static let accelY_UUID = CBUUID(string: accelYCharUuid)
    static let accelZ_UUID = CBUUID(string: accelZCharUuid)
    
    static let gyroX_UUID = CBUUID(string: gyroXCharUuid)
    static let gyroY_UUID = CBUUID(string: gyroYCharUuid)
    static let gyroZ_UUID = CBUUID(string: gyroZCharUuid)

}
