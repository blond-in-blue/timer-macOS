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
    var timer = Foundation.Timer()
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
    @IBOutlet weak var timeLabelLeft: NSTextField!
    @IBOutlet weak var timeLabelRight: NSTextField!
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
    
    func initializeTimerView() {
        timerIsActive = false
        startButtonHasBeenPressed = false
        pauseButtonHasBeenPressed = false
        pauseButton?.isEnabled = false
        
        timerCounter = timerCounterInitial
        timerSeconds.stringValue = ""
        timerMinutes.stringValue = ""
        timerHours.stringValue = ""
        startButton.title = "Start"
        pauseButton.title = "Pause"
        timerSeconds.isEnabled = true
        timerMinutes.isEnabled = true
        timerHours.isEnabled = true
        timerSeconds.isSelectable = true
        timerMinutes.isSelectable = true
        timerHours.isSelectable = true
        timerSeconds.isEditable = true
        timerMinutes.isEditable = true
        timerHours.isEditable = true
    }
    
    func timerCountdown(_ sender: NSObject) {
        
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
            pauseButton.isEnabled = false
            timerSeconds.isSelectable = true
            timerMinutes.isSelectable = true
            timerHours.isSelectable = true
            timerSeconds.isEditable = true
            timerMinutes.isEditable = true
            timerHours.isEditable = true
            
            timerSeconds.isEnabled = true
            timerMinutes.isEnabled = true
            timerHours.isEnabled = true
            
            revealAlertView()
//            Start timer alert sound
            alertSound!.loops = true
            alertSound!.play()
//            Timer for alert
            timer = Foundation.Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timerAlert), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        else if timerCounter > 0 {
            displayCountdownValues()
            //            Exiting the timer window stops the counter
        }
    }
    
    func displayCountdownValues() {
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
    
    @IBAction func startOrCancelTimer(_ sender: AnyObject) {
        
        if startButton.isHidden == false {
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
            pauseButton.isEnabled = true
            
            displayCountdownValues()
//            Timer for timer countdown
            timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            
            timerSeconds.isEnabled = false
            timerMinutes.isEnabled = false
            timerHours.isEnabled = false
            timerSeconds.isSelectable = false
            timerMinutes.isSelectable = false
            timerHours.isSelectable = false
        }
    }
    
    func cancelTimer() {
        timer.invalidate()

        initializeTimerView()
    }

    @IBAction func pauseOrResumeTimer(_ sender: AnyObject) {
   
        if pauseButton.isHidden == false {
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
        timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
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
    
    @IBAction func dismissAlert(_ sender: AnyObject) {
        
        if dismissAlertButton.isHidden == false {
            timerIsActive = false
//            Stop blinking label timer
            
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
        NSApplication.shared().activate(ignoringOtherApps: true)
//        Disable the window close button.
        self.view.window!.standardWindowButton(NSWindowButton.closeButton)!.isEnabled = false
        //self.view.window?.styleMask = NSTexturedBackgroundWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        
        timerSeconds.isHidden = true
        timerMinutes.isHidden = true
        timerHours.isHidden = true
        timeLabelLeft.isHidden = true
        timeLabelRight.isHidden = true
        pauseButton.isHidden = true
        startButton.isHidden = true
        
        alertLabel.isHidden = false
        dismissAlertButton.isHidden = false

    }
    
//    Should show when switching from Alert view
    func revealTimerView() {
        
//        Enable the window close button.
        //NSApplication.shared().windows.first?.styleMask = NSTexturedBackgroundWindowMask | NSClosableWindowMask |  NSMiniaturizableWindowMask | NSTitledWindowMask
        self.view.window!.standardWindowButton(NSWindowButton.closeButton)!.isEnabled = true
        
        timerSeconds.isHidden = false
        timerMinutes.isHidden = false
        timerHours.isHidden = false
        timeLabelLeft.isHidden = false
        timeLabelRight.isHidden = false
        pauseButton.isHidden = false
        startButton.isHidden = false
        
        alertLabel.isHidden = true
        dismissAlertButton.isHidden = true
    }

    @IBAction func toggleFloatWindowOnTop(_ sender: NSMenuItem) {
        
        //self.view.window?.level == sender.state ? Int(CGWindowLevelForKey(.FloatingWindowLevelKey)) : Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
        
        if self.view.window?.level == Int(CGWindowLevelForKey(.normalWindow)) {
            self.view.window!.level =  Int(CGWindowLevelForKey(.floatingWindow))
        }
        else {
            self.view.window?.level = Int(CGWindowLevelForKey(.normalWindow))
        }
        
        if sender.state == 1 {
            sender.state = 0
        }
        else {
            sender.state = 1
        }
    }
}

