//
//  TSCVibeWindow.swift
//  Vibe
//
//  Created by Thomas Schoffelen on 18/06/2016.
//  Copyright © 2016 thomasschoffelen. All rights reserved.
//

import Cocoa

typealias StatsDictionary = Dictionary<String,[String:Int]>

class TSCVibeWindow: NSWindow {
    
    @IBOutlet var weekGraph : NSView!
    @IBOutlet var monthGraph : NSView!
    @IBOutlet var weekdayGraph : NSView!
    
    @IBOutlet var titleLabel : NSTextField!
    @IBOutlet var subtitleLabel : NSTextField!
    
    func displayStats(_ stats: StatsDictionary?) {
        self.renderWeekGraph(stats)
        self.renderMonthGraph(stats)
        self.renderWeekdayGraph(stats)
        
        guard let stats = stats else {
            titleLabel.stringValue = "Update Failed."
            subtitleLabel.stringValue = "Execute AppleScript Failed."
            return
        }
        
        titleLabel.stringValue = "\(stats["totals"]!["complete"]!) tasks completed."
        subtitleLabel.stringValue = "\(stats["totals"]!["incomplete"]!) tasks are currently open."
    }
    
    internal func renderWeekGraph(_ stats: StatsDictionary?) {
        guard let daysData = stats?["days"] else {
            return
        }
        
        let chartView = TSCBarChartView(frame: CGRect(x: 0,y: 0, width: self.weekGraph.frame.width, height: self.weekGraph.frame.height), barData: daysData, barColor: NSColor(red:0.14, green:0.65, blue:0.94, alpha:1.00));
        chartView.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width];
        chartView.translatesAutoresizingMaskIntoConstraints = true;
        
        self.weekGraph.addSubview(chartView);
    }
    
    internal func renderMonthGraph(_ stats: StatsDictionary?) {
        guard let monthData = stats?["months"] else {
            return
        }
        
        let chartView = TSCBarChartView(frame: CGRect(x: 0,y: 0,width: self.monthGraph.frame.width, height: self.monthGraph.frame.height), barData:monthData , barColor: NSColor(red:0.97, green:0.25, blue:0.44, alpha:1.00));
        chartView.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width];
        chartView.translatesAutoresizingMaskIntoConstraints = true;
        
        self.monthGraph.addSubview(chartView);
    }
    
    internal func renderWeekdayGraph(_ stats: StatsDictionary?) {
        guard let weekdaysData = stats?["weekdays"] else {
            return
        }
        
        let chartView = TSCBarChartView(frame: CGRect(x: 0, y: 0, width: self.weekdayGraph.frame.width, height: self.weekdayGraph.frame.height), barData: weekdaysData, barColor: NSColor(red:0.97, green:0.82, blue:0.20, alpha:1.00));
        chartView.autoresizingMask = [NSView.AutoresizingMask.height, NSView.AutoresizingMask.width];
        chartView.translatesAutoresizingMaskIntoConstraints = true;
        
        self.weekdayGraph.addSubview(chartView);
    }
    
}
