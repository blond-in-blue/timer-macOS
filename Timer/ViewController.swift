//
//  ViewController.swift
//  Timer
//
//  Created by Hunter Holder on 3/17/16.
//  Copyright © 2016 Hunter Holder. All rights reserved.
//


// Ideas
// If any text field is being edited or contains values, enable timer colons. Otherwise, disable timer colons.

import Cocoa

class ViewController: NSViewController {

//    Timer general variables
    var timer = NSTimer()
    var timerCounter = 0
    let timerCounterInitial = 0
    var alertCounter = 0
    let alertCounterInitial = 240
    var timerIsActive = false
    var startButtonHasBeenPressed = false
    var pauseButtonHasBeenPressed = false
//    Alert sound
    let alertSound = NSSound(data: NSDataAsset(name: "Hillside")!.data)
//    Timer view
    @IBOutlet weak var floatingStatusLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var timerSeconds: NSTextField!
    @IBOutlet weak var timerMinutes: NSTextField!
    @IBOutlet weak var timerHours: NSTextField!
//    Alert view
    @IBOutlet weak var alertLabel: NSTextField!
    @IBOutlet weak var dismissAlertButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeTimerView()
        timerCounter = timerCounterInitial
        alertCounter = alertCounterInitial
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
            
        }
    }
    
    func initializeTimerView() {
        timerIsActive = false
        startButtonHasBeenPressed = false
        pauseButtonHasBeenPressed = false
        pauseButton?.enabled = false
        
        timerCounter = timerCounterInitial
        timerSeconds.stringValue = ""
        timerMinutes.stringValue = ""
        timerHours.stringValue = ""
        startButton.title = "Start"
        pauseButton.title = "Pause"
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
    
    func timerCountdown(sender: NSObject) {
        
        timerIsActive = true
        timerCounter = timerCounter - 1
        
        if timerCounter <= 0 {
            timer.invalidate()
            timerCounter = timerCounterInitial
            timerSeconds.stringValue = ""
            timerMinutes.stringValue = ""
            timerHours.stringValue = ""
            timerIsActive = false
            startButton.title = "Start"
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
            
            revealAlertView()
//            Start timer alert sound
            alertSound!.loops = true
            alertSound!.play()
//            Timer for alert
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.timerAlert), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
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
//            Exiting the timer window stops the counter
        }
    }
    
    @IBAction func startOrCancelTimer(sender: AnyObject) {
        
        if startButton.hidden == false {
            if timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "" {
                timerIsActive = !timerIsActive
                startButtonHasBeenPressed = !startButtonHasBeenPressed
                
                if timerIsActive == false || pauseButtonHasBeenPressed == true {
                    
                    cancelTimer()
                }
                else if timerIsActive == true {
                    
                    startTimer()
                }
            }
        }
    }
    
    func startTimer() {
        
        timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue

        if timerCounter >= 0 {
            
            startButton.title = "Cancel"
            timerIsActive = true
            pauseButton.enabled = true
            
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
            
            //                    Timer for timer countdown
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            
            timerSeconds.enabled = false
            timerMinutes.enabled = false
            timerHours.enabled = false
            timerSeconds.selectable = false
            timerMinutes.selectable = false
            timerHours.selectable = false
        }
    }
    
    func cancelTimer() {
        timer.invalidate()

        initializeTimerView()
    }

    @IBAction func pauseOrResumeTimer(sender: AnyObject) {
   
        if pauseButton.hidden == false {
            if (timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "") && startButtonHasBeenPressed == true {
                
                pauseButtonHasBeenPressed = !pauseButtonHasBeenPressed
                
                if timerIsActive == true {
                    pauseTimer()
                }
                else if timerIsActive == false {
                    resumeTimerFromPause()
                }
                
                timerIsActive = !timerIsActive
            }
        }
    }
    
    func pauseTimer() {
        timer.invalidate()
        pauseButton.title = "Resume"
    }
    
    func resumeTimerFromPause() {
        timerCounter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
        
        //                    Timer for timer countdown
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        pauseButton.title = "Pause"
    }
    
//    Count down until the alert period ends, then stop the alert but do not dismiss the alert view.
    func timerAlert() {
        
        alertCounter -= 1
        
        if alertCounter == 0 {
            //        Stop alert sound
            alertSound!.stop()
            //        End countdown
            timer.invalidate()
        }
    }
    
    @IBAction func dismissAlert(sender: AnyObject) {
        
        if dismissAlertButton.hidden == false {
            timerIsActive = false
            
    //        Stop alert sound
            alertSound!.stop()
    //        Reset countdown
            timer.invalidate()
            alertCounter = alertCounterInitial
            revealTimerView()
        }
    }
    
//    Should show when switching from Timer view
    func revealAlertView() {
        
//        Make sure the window is open and bring the window to the front.
        self.view.window?.makeKeyAndOrderFront(self)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
//        Disable the window close button.
        NSApplication.sharedApplication().windows.first?.styleMask = NSTexturedBackgroundWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        
        timerSeconds.hidden = true
        timerMinutes.hidden = true
        timerHours.hidden = true
        timeLabel.hidden = true
        pauseButton.hidden = true
        startButton.hidden = true
        
        alertLabel.hidden = false
        dismissAlertButton.hidden = false

    }
    
//    Should show when switching from Alert view
    func revealTimerView() {
        
//        Enable the window close button.
        NSApplication.sharedApplication().windows.first?.styleMask = NSTexturedBackgroundWindowMask | NSClosableWindowMask |  NSMiniaturizableWindowMask | NSTitledWindowMask
        
        timerSeconds.hidden = false
        timerMinutes.hidden = false
        timerHours.hidden = false
        timeLabel.hidden = false
        pauseButton.hidden = false
        startButton.hidden = false
        
        alertLabel.hidden = true
        dismissAlertButton.hidden = true
    }

    @IBAction func toggleFloatWindowOnTop(sender: NSMenuItem) {
        
        //self.view.window?.level == sender.state ? Int(CGWindowLevelForKey(.FloatingWindowLevelKey)) : Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        
        if self.view.window?.level == Int(CGWindowLevelForKey(.NormalWindowLevelKey)) {
            self.view.window!.level =  Int(CGWindowLevelForKey(.MaximumWindowLevelKey))
        }
        else {
            self.view.window?.level = Int(CGWindowLevelForKey(.NormalWindowLevelKey))
        }
        
        if sender.state == 1 {
            sender.state = 0
            floatingStatusLabel.textColor = NSColor.tertiaryLabelColor()
        }
        else {
            sender.state = 1
            floatingStatusLabel.textColor = NSColor(red:0.359, green:0.624, blue:0.949, alpha:1)
        }
    }
}

