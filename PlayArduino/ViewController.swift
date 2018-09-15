//
//  ViewController.swift
//  PlayArduino
//
//  Created by kawakami takahiro on 2018/09/09.
//  Copyright © 2018年 kawakami takahiro. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    var centralManagerReady: Bool = false
    var peripheralReady: Bool = false
    
    @IBOutlet weak var BLESSIDLabel: UILabel!
    
    @IBAction func handleConnectButtonTouch(_ sender: Any) {
        guard centralManagerReady else {
            return
        }
        scanBLESerial3()
    }
    
    @IBAction func handleSend1ButtonTouch(_ sender: Any) {
        guard peripheralReady else {
            return
        }
        var val: Int = 1
        let data = Data.init(bytes: &val, count: 1)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    @IBAction func handleSend2ButtonTouch(_ sender: Any) {
        guard peripheralReady else {
            return
        }
        var val: Int  = 2
        let data = Data.init(bytes: &val, count: 1)
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - CBCentralManager Delegate

    // CBCentralManagerの状態が変化するたびに呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.centralManagerReady = true
        default:
            break
        }
    }

    // Scanをして、該当のBLE(ペリフェラル)が見つかると呼ばれる
    // 第2引数に該当のBLE（ペリフェラル）が渡されてくる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("発見したBLE: \(peripheral)")
        self.stopScan()
        self.connectPeripheral(peripheral: peripheral)
    }

    // BLE（ペリフェラル）に接続が成功すると呼ばれる
    // 第2引数に接続したBLE（ペリフェラル）が渡されてくる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続したBLE: \(peripheral)")
        self.BLESSIDLabel.text = peripheral.name
        self.scanService()
    }

    // MARK: - CBPeripheralDelegate Delegate

    // サービスを発見すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let service: CBService = peripheral.services![0]
        self.scanCharacteristics(service)
    }

    // キャラスタリスティックを発見すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let characteristic: CBCharacteristic = service.characteristics![0]
        self.characteristic = characteristic

        peripheralReady = true
    }

    // MARK: - Method

    func scanBLESerial3() {
        let BLESerial3UUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
        self.centralManager?.scanForPeripherals(withServices: BLESerial3UUID, options: nil)
    }

    func stopScan() {
        self.centralManager.stopScan()
    }

    func connectPeripheral(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.centralManager.connect(self.peripheral, options: nil)
    }

    func scanService() {
        self.peripheral.delegate = self
        let TXCBUUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
        self.peripheral.discoverServices(TXCBUUID)
    }

    func scanCharacteristics(_ service: CBService) {
        let characteristics: [CBUUID] = [CBUUID.init(string: "FEEDAA02-C497-4476-A7ED-727DE7648AB1")]
        self.peripheral.discoverCharacteristics(characteristics, for: service)
    }

}

