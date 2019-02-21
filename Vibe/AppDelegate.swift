//
//  AppDelegate.swift
//  Vibe
//
//  Created by Thomas Schoffelen on 18/06/2016.
//  Copyright © 2016 thomasschoffelen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: TSCVibeWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window.titlebarAppearsTransparent = true
        self.window.isMovableByWindowBackground = true
        self.window.styleMask.insert(.fullSizeContentView)
        self.window.backgroundColor = NSColor(red:0.15, green:0.16, blue:0.18, alpha:1.00)
        
        self.window.makeKey()
        self.window.makeMain()
    
        self.updateStats()
        
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.updateStats()
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func updateStats() {
        DispatchQueue.global().async {
            let stats = TSCStatsLoader.getStats();
            DispatchQueue.main.async {
                self.window.displayStats(stats);
            }
        }
    }
}

