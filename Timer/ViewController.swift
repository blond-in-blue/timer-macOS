//
//  ViewController.swift
//  Timer
//
//  Created by Hunter Holder on 3/17/16.
//  Copyright © 2016 Hunter Holder. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

// Ideas
// If any text field is being edited or contains values, enable timer colons. Otherwise, disable timer colons.

import Cocoa

class ViewController: NSViewController {
    
//    Timer class
    let timer = Timer()
    
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
        timer.counter = timer.counterInitial
        timer.alert.counter = timer.alert.counterInitial
        
    }
    
    func initializeTimerView() {
        timer.isActive = false
        timer.startButtonHasBeenPressed = false
        timer.pauseButtonHasBeenPressed = false
        pauseButton?.isEnabled = false
        
        timer.counter = timer.counterInitial
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
        
        timer.isActive = true
        timer.counter = timer.counter - 1
        
        if timer.counter <= 0 {
            timer.timer.invalidate()
            timer.counter = timer.counterInitial
            timerSeconds.stringValue = ""
            timerMinutes.stringValue = ""
            timerHours.stringValue = ""
            timer.isActive = false
            startButton.title = "Start"
            timer.startButtonHasBeenPressed = false
            timer.pauseButtonHasBeenPressed = false
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
            timer.alert.sound!.loops = true
            timer.alert.sound!.play()
//            Timer for alert
            timer.timer = Foundation.Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timerAlert), userInfo: nil, repeats: true)
            RunLoop.main.add(timer.timer, forMode: RunLoopMode.commonModes)
        }
        else if timer.counter > 0 {
            displayCountdownValues()
            //            Exiting the timer window stops the counter
        }
    }
    
    func displayCountdownValues() {
        timerSeconds.stringValue = "\(timer.counter % 60)"
        timerMinutes.stringValue = "\((timer.counter / 60) % 60)"
        timerHours.stringValue = "\((timer.counter / 3600) % 24)"
        
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
                timer.isActive = !timer.isActive
                timer.startButtonHasBeenPressed = !timer.startButtonHasBeenPressed
                
                if timer.isActive == false || timer.pauseButtonHasBeenPressed == true {
                    
                    cancelTimer()
                }
                else if timer.isActive == true {
                    
                    startTimer()
                }
            }
        }
    }
    
    func startTimer() {
        
        timer.counter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue

        if timer.counter >= 0 {
            
            startButton.title = "Cancel"
            timer.isActive = true
            pauseButton.isEnabled = true
            
            displayCountdownValues()
//            Timer for timer countdown
            timer.timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
            RunLoop.main.add(timer.timer, forMode: RunLoopMode.commonModes)
            
            timerSeconds.isEnabled = false
            timerMinutes.isEnabled = false
            timerHours.isEnabled = false
            timerSeconds.isSelectable = false
            timerMinutes.isSelectable = false
            timerHours.isSelectable = false
        }
    }
    
    func cancelTimer() {
        timer.timer.invalidate()

        initializeTimerView()
    }

    @IBAction func pauseOrResumeTimer(_ sender: AnyObject) {
   
        if pauseButton.isHidden == false {
            if (timerSeconds.stringValue != "" || timerMinutes.stringValue != "" || timerHours.stringValue != "") && timer.startButtonHasBeenPressed == true {
                
                timer.pauseButtonHasBeenPressed = !timer.pauseButtonHasBeenPressed
                
                if timer.isActive == true {
                    pauseTimer()
                }
                else if timer.isActive == false {
                    resumeTimerFromPause()
                }
                
                timer.isActive = !timer.isActive
            }
        }
    }
    
    func pauseTimer() {
        timer.timer.invalidate()
        pauseButton.title = "Resume"
    }
    
    func resumeTimerFromPause() {
        timer.counter = (timerHours.integerValue * 3600) + (timerMinutes.integerValue * 60) + timerSeconds.integerValue
        
        //                    Timer for timer countdown
        timer.timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerCountdown), userInfo: nil, repeats: true)
        RunLoop.main.add(timer.timer, forMode: RunLoopMode.commonModes)
        
        pauseButton.title = "Pause"
    }
    
//    Count down until the alert period ends, then stop the alert but do not dismiss the alert view.
    func timerAlert() {
        
        timer.alert.counter -= 1
        
        if timer.alert.counter == 0 {
            //        Stop alert sound
            timer.alert.sound!.stop()
            //        End countdown
            timer.timer.invalidate()
        }
    }
    
    @IBAction func dismissAlert(_ sender: AnyObject) {
        
        if dismissAlertButton.isHidden == false {
            timer.isActive = false
//            Stop blinking label timer
            
    //        Stop alert sound
            timer.alert.sound!.stop()
    //        Reset countdown
            timer.timer.invalidate()
            timer.alert.counter = timer.alert.counterInitial
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
