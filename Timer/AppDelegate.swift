//
//  AppDelegate.swift
//  Timer
//
//  Created by Hunter Holder on 3/17/16.
//  Copyright © 2016 Hunter Holder. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        
        if !flag{
            
            for window in sender.windows{
                if let windowMage = window as? NSWindow {
                    windowMage.makeKeyAndOrderFront(self)
                }
            }
        }
        
        return true
    }
}

