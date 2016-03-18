//
//  ViewController.swift
//  Timer
//
//  Created by Hunter Holder on 3/17/16.
//  Copyright © 2016 Hunter Holder. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var timerIsActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        timerIsActive = false

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startTimer(sender: AnyObject) {
        timerIsActive = !timerIsActive
        
        
    }

    @IBAction func pauseTimer(sender: AnyObject) {
    }
    
    @IBAction func setHours(sender: AnyObject) {
        if !timerIsActive {
            
        }
    }
    
    @IBAction func setMinutes(sender: AnyObject) {
        if !timerIsActive {
            
        }
    }
    
    @IBAction func setSeconds(sender: AnyObject) {
        if !timerIsActive {
            
        }
    }
}

