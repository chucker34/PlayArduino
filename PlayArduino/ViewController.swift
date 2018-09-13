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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

