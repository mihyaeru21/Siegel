//
//  ViewController.swift
//  Siegel
//
//  Created by Mihyaeru on 07/24/2015.
//  Copyright (c) 2015 Mihyaeru. All rights reserved.
//

import UIKit
import Siegel

class Hoge {
    let uuid = NSUUID().UUIDString
    init() { println("init: \(self.uuid)")   }
    deinit { println("deinit: \(self.uuid)") }
}

class ViewController: UIViewController {
    let cache: Siegel<Hoge> = Siegel<Hoge>(size: 3)

    @IBAction func add() {
        let hoge = Hoge()
        self.cache.set(key: hoge.uuid, value: hoge)
    }
}

