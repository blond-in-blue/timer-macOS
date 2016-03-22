//
//  ViewController.swift
//  Timer
//
//  Created by Hunter Holder on 3/17/16.
//  Copyright © 2016 Hunter Holder. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var timer = NSTimer()
    var timerCounter = 0
    var alertCounter = 120
    var timerIsActive = false
    var startButtonHasBeenPressed = false
    var pauseButtonHasBeenPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeTimerView()
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
    }
    
    func initializeTimerView() {
        timerIsActive = false
        startButtonHasBeenPressed = false
        pauseButtonHasBeenPressed = false
        pauseButton?.enabled = false
    }
    
    func timerCountdown() {
        
        timerIsActive = true
        timerCounter -= 1
        
        if timerCounter == 0 {
            timer.invalidate()
            timerCounter = 0
            timerSeconds.stringValue = ""
            timerMinutes.stringValue = ""
            timerHours.stringValue = ""
            timerIsActive = false
            startCancelButton.title = "Start"
            startButtonHasBeenPressed = false
            pauseButtonHasBeenPressed = false
            pauseButton.enabled = false
            timerSeconds.selectable = true
            timerMinutes.selectable = true
            timerHours.selectable = true
            timerSeconds.editable = true
            timerMinutes.editable = true
            timerHours.editable = true
            
            timerSeconds.enabled = true
            timerMinutes.enabled = true
            timerHours.enabled = true
            
            performSegueWithIdentifier("alertView", sender: nil)
            
//            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.showAlert), userInfo: nil, repeats: true)
        }
        else if timerCounter > 0 {
            timerSeconds.stringValue = "\(timerCounter % 60)"
            timerMinutes.stringValue = "\((timerCounter / 60) % 60)"
            timerHours.stringValue = "\((timerCounter / 3600) % 24)"
            
            if timerSeconds.stringValue == "0" {
                timerSeconds.stringValue = "00"
            }
            if timerMinutes.stringValue == "0" {
                timerMinutes.stringValue = "00"
            }
            if timerHours.stringValue == "0" {
                timerHours.stringValue = "00"
            }
        }
    }
    
    @IBOutlet weak var timeLabel: NSTextFieldCell!
    @IBOutlet weak var startCancelButton: NSButtonCell!
    @IBOutlet weak var pauseButton: NSButtonCell!
    @IBOutlet weak var timerSeconds: NSTextField!
    @IBOutlet weak var timerMinutes: NSTextField!
    @IBOutlet weak var timerHours: NSTextField!
    @IBOutlet weak var alertLabel: NSTextField!
    
    @IBAction func startTimer(sender: AnyObject) {
        
        if timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "" {
            timerIsActive = !timerIsActive
            startButtonHasBeenPressed = !startButtonHasBeenPressed
            
            if timerIsActive == false || pauseButtonHasBeenPressed == true {
                
                timer.invalidate()
                timerCounter = 0
                timerSeconds.stringValue = ""
                timerMinutes.stringValue = ""
                timerHours.stringValue = ""
                
                startCancelButton.title = "Start"
                pauseButton.title = "Pause"
                timerIsActive = false
                pauseButton.enabled = false
                pauseButtonHasBeenPressed = false
                
                timerSeconds.enabled = true
                timerMinutes.enabled = true
                timerHours.enabled = true

                timerSeconds.selectable = true
                timerMinutes.selectable = true
                timerHours.selectable = true
                timerSeconds.editable = true
                timerMinutes.editable = true
                timerHours.editable = true

            }
            else if timerIsActive == true {
                
                timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
                
                if timerCounter != 0 {

                    startCancelButton.title = "Cancel"
                    timerIsActive = true
                    pauseButton.enabled = true
                    
                    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
                    
                    
                    timerSeconds.enabled = false
                    timerMinutes.enabled = false
                    timerHours.enabled = false
                    
                    timerSeconds.selectable = false
                    timerMinutes.selectable = false
                    timerHours.selectable = false
                }
            }
        }
    }

    @IBAction func pauseTimer(sender: AnyObject) {
   
        if (timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "") && startButtonHasBeenPressed == true {
            
            pauseButtonHasBeenPressed = !pauseButtonHasBeenPressed
            
            if timerIsActive == true {
                timer.invalidate()
                pauseButton.title = "Resume"
            }
            else if timerIsActive == false {
                
                timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
                
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
                
                pauseButton.title = "Pause"
            }
            
            timerIsActive = !timerIsActive
        }
    }
    
    func showAlert() {
        
        alertCounter -= 1
        
        if alertCounter == 0 {
            timer.invalidate()
            alertCounter = 120
            alertLabel?.alphaValue = 1
        }
        else if alertLabel?.alphaValue == 0.5 {
            alertLabel.alphaValue = 1
        }
        else if alertLabel?.alphaValue == 1 {
            alertLabel.alphaValue = 0.5
        }
    }
    
    @IBAction func dismissAlert(sender: AnyObject) {
        timer.invalidate()
        alertCounter = 120
//        dismissViewController(NSviewcon)
    }
}

