//
//  SwingSensorDevice.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import Foundation
import CoreBluetooth

@Observable
class BLESwingSensor: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate, SwingSensorDevice {
    
    // Data Acquisition
    private var rawGyroX: Double = 0.0
    private var rawGyroY: Double = 0.0
    private var rawGyroZ: Double = 0.0
    
    private var rawAccelX: Double = 0.0
    private var rawAccelY: Double = 0.0
    private var rawAccelZ: Double = 0.0
    
    // Last Filtered Readings
    private var lastFilteredGyroX: Double = 0.0
    private var lastFilteredGyroY: Double = 0.0
    private var lastFilteredGyroZ: Double = 0.0
    
    private var lastFilteredAccelX: Double = 0.0
    private var lastFilteredAccelY: Double = 0.0
    private var lastFilteredAccelZ: Double = 0.0

    
    // Data Access
    var accelX: Double {
        Filters.lowPassFilter(newReading: rawAccelX, previousReading: lastFilteredAccelX)
    }
    var accelY: Double {
        Filters.lowPassFilter(newReading: rawAccelY, previousReading: lastFilteredAccelY)
    }
    var accelZ: Double {
        Filters.lowPassFilter(newReading: rawAccelZ, previousReading: lastFilteredAccelZ)
    }
    var gyroX: Double {
        Filters.lowPassFilter(newReading: rawGyroX, previousReading: lastFilteredGyroX)
    }
    var gyroY: Double {
        Filters.lowPassFilter(newReading: rawGyroY, previousReading: lastFilteredGyroY)
    }
    var gyroZ: Double {
        Filters.lowPassFilter(newReading: rawGyroZ, previousReading: lastFilteredGyroZ)
    }
    
    var isConnected: Bool = false
    var devices: [CBPeripheral] = []
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    private var characteristics: [String: CBCharacteristic] = [:]
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
            startScanning()
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
    }
    
    func startScanning() -> Void {
        // Start Scanning
        print("Started scanning")
        centralManager.scanForPeripherals(withServices: [Devices.BLEService_UUID])
    }
    
    // Update the following method to identify your specific BLE device and characteristics
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        devices.append(peripheral)
        self.peripheral = peripheral
        peripheral.delegate = self
        
        print("Peripheral Discovered: \(peripheral)")
        print("Peripheral name: \(String(describing: peripheral.name))")
        print ("Advertisement Data : \(advertisementData)")
        
        centralManager?.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([Devices.BLEService_UUID])
    }
    
    // called when a peripherals services are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")
        
        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let services = peripheral.services else {
            return
        }
        //We need to discover the all characteristic
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        print("Discovered Services: \(services)")
    }
    
    // called when a services characteristics are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let discoveredCharacteristics = service.characteristics else {
            return
        }
        self.isConnected = true
        print("Found \(discoveredCharacteristics.count) characteristics.")
        
        for characteristic in discoveredCharacteristics {
            
            
            characteristics[characteristic.uuid.uuidString] = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
            print("Discovered characteristic: \(characteristic.uuid)")
//            if characteristic.uuid.isEqual(Devices.accelX_UUID)  {
//                accelXCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: accelXCharacteristic)
//                peripheral.readValue(for: accelXCharacteristic)
//                characteristics[Devices.accelXCharUuid] = characteristic
//
//                print("AccelX Characteristic: \(accelYCharacteristic.uuid)")
//            } else if characteristic.uuid.isEqual(Devices.accelY_UUID) {
//                accelYCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: accelYCharacteristic)
//                peripheral.readValue(for: accelYCharacteristic)
//
//                print("AccelX Characteristic: \(accelZCharacteristic.uuid)")
//            } else if characteristic.uuid.isEqual(Devices.accelZ_UUID) {
//                accelZCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: accelZCharacteristic)
//                peripheral.readValue(for: accelZCharacteristic)
//
//                print("AccelZ Characteristic: \(gyroXCharacteristic.uuid)")
//            } else if characteristic.uuid.isEqual(Devices.gyroX_UUID) {
//                gyroXCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: gyroXCharacteristic)
//                peripheral.readValue(for: gyroXCharacteristic)
//
//                print("GyroX Characteristic: \(gyroYCharacteristic.uuid)")
//            } else if characteristic.uuid.isEqual(Devices.gyroY_UUID) {
//                gyroYCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: gyroYCharacteristic)
//                peripheral.readValue(for: gyroYCharacteristic)
//
//                print("GyroX Characteristic: \(gyroZCharacteristic.uuid)")
//            } else if characteristic.uuid.isEqual(Devices.gyroZ_UUID) {
//                gyroZCharacteristic = characteristic
//                peripheral.setNotifyValue(true, for: gyroZCharacteristic)
//                peripheral.readValue(for: gyroZCharacteristic)
//
//                print("GyroX Characteristic: \(gyroXCharacteristic.uuid)")
//            }
        }
    }

    // Read and update values when new data is received
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let char = characteristics[characteristic.uuid.uuidString] else {
            return
        }
        guard let value = char.value else {
            return
        }
        //let characteristicString = NSString(data: value!, encoding: String.Encoding.utf8.rawValue)
        let valueAsDouble = Data(value).withUnsafeBytes { $0.load(as: Double.self) }
        
        // set corresponding var to char
        if char.uuid.uuidString == Devices.accelXCharUuid {
            rawAccelX = valueAsDouble
        } else if char.uuid.uuidString == Devices.accelYCharUuid {
            rawAccelY = valueAsDouble
        } else if char.uuid.uuidString == Devices.accelZCharUuid {
            rawAccelZ = valueAsDouble
        } else if char.uuid.uuidString == Devices.gyroXCharUuid {
            rawGyroX = valueAsDouble
        } else if char.uuid.uuidString == Devices.gyroYCharUuid {
            rawGyroY = valueAsDouble
        } else if char.uuid.uuidString == Devices.gyroZCharUuid {
            rawGyroZ = valueAsDouble
        }
    }
    
    func disconnectFromDevice () {
        if peripheral != nil {
            self.isConnected = false
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
}

extension BLESwingSensor: CBPeripheralManagerDelegate {

  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    switch peripheral.state {
    case .poweredOn:
        print("Peripheral Is Powered On.")
    case .unsupported:
        print("Peripheral Is Unsupported.")
    case .unauthorized:
    print("Peripheral Is Unauthorized.")
    case .unknown:
        print("Peripheral Unknown")
    case .resetting:
        print("Peripheral Resetting")
    case .poweredOff:
      print("Peripheral Is Powered Off.")
    @unknown default:
      print("Error")
    }
  }
}

extension CBPeripheral: Identifiable {
    
}
