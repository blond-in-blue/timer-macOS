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
        
        timerIsActive = false
        startButtonHasBeenPressed = false
        pauseButtonHasBeenPressed = false
        
        pauseButton?.enabled = false
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
    }
    
    @IBOutlet weak var timeLabel: NSTextFieldCell!
    @IBOutlet weak var startCancelButton: NSButtonCell!
    @IBOutlet weak var pauseButton: NSButtonCell!
    @IBOutlet weak var timerSeconds: NSTextField!
    @IBOutlet weak var timerMinutes: NSTextField!
    @IBOutlet weak var timerHours: NSTextField!
    @IBOutlet weak var alertLabel: NSTextField!

    @IBOutlet weak var secondsField: NSNumberFormatter!
    @IBOutlet weak var minutesField: NSNumberFormatter!
    @IBOutlet weak var hoursField: NSNumberFormatter!
    
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
            }
            else if timerIsActive == true {
                
                timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
                
                startCancelButton.title = "Cancel"
                timerIsActive = true
                pauseButton.enabled = true
                
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerCountdown", userInfo: nil, repeats: true)
            }
        }
    }
    
    func timerCountdown() {
        
        timerIsActive = true
        --timerCounter
        
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
            
//            performSegueWithIdentifier("alertView", sender: nil)
            
//            NSNotificationCenter.defaultCenter().postNotificationName("NotificationIdentifier", object: nil)

            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "showAlert", userInfo: nil, repeats: true)
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

    @IBAction func pauseTimer(sender: AnyObject) {
   
        if (timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "") && startButtonHasBeenPressed == true {
            
            pauseButtonHasBeenPressed = !pauseButtonHasBeenPressed
            
            if timerIsActive == true {
                timer.invalidate()
                pauseButton.title = "Resume"
            }
            else if timerIsActive == false {
                
                timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
                
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerCountdown", userInfo: nil, repeats: true)
                
                pauseButton.title = "Pause"
            }
            
            timerIsActive = !timerIsActive
        }
    }
    
    func showAlert() {
        
        --alertCounter
        
        if alertCounter == 0 {
            timer.invalidate()
            
        }
        else if alertLabel?.alphaValue == 0.5 {
            alertLabel.alphaValue = 1
            alertLabel.textColor = NSColor.greenColor()
        }
        else if alertLabel?.alphaValue == 1 {
            alertLabel.alphaValue = 0.5
            alertLabel.textColor = NSColor.blueColor()

        }
    }
    
    @IBAction func dismissAlert(sender: AnyObject) {
        timer.invalidate()
        
    }
}

