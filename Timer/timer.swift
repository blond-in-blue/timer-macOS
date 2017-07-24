//
//  timer.swift
//  Timer class file
//
//  Created by Hunter Holder on 7/12/17.
//  Copyright © 2017 Hunter Holder. All rights reserved.
//

import Foundation
import Cocoa

//    Alert sound
struct TimerAlert {
    let sound = NSSound(data: NSDataAsset(name: "Hillside")!.data)
    var counter = 0
    let counterInitial = 240
}

class Timer {
    var alert = TimerAlert()
    var timer = Foundation.Timer()
    var counter = 0
    let counterInitial = 0
    var isActive = false
    var startButtonHasBeenPressed = false
    var pauseButtonHasBeenPressed = false
}
