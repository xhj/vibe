//
//  TSCStatsLoader.swift
//  Vibe
//
//  Created by Thomas Schoffelen on 18/06/2016.
//  Copyright © 2016 thomasschoffelen. All rights reserved.
//

import Foundation

class TSCStatsLoader {
    
    static func getStats() -> Dictionary<String,[String:Int]>? {
        
        /// this AppleScript check OmniFocus all the completed TODOs
        /// output is the completion dates
        let myAppleScript = "set theProgressDetail to \"\"\ntell application \"OmniFocus\"\ntell front document\nset theModifiedProjects to every flattened project\nrepeat with a from 1 to length of theModifiedProjects\nset theCompletedTasks to (every flattened task of (item a of theModifiedProjects) where its number of tasks = 0)\nif theCompletedTasks is not equal to {} then\nrepeat with b from 1 to length of theCompletedTasks\nset theProgressDetail to theProgressDetail & completion date of (item b of theCompletedTasks) & return\nend repeat\nend if\nend repeat\nset theInboxCompletedTasks to (every inbox task where its number of tasks = 0)\nrepeat with d from 1 to length of theInboxCompletedTasks\nset theProgressDetail to theProgressDetail & completion date of (item d of theInboxCompletedTasks) & return\nend repeat\nend tell\nend tell\nreturn theProgressDetail"
        
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            var error: NSDictionary?
            let output = scriptObject.executeAndReturnError(&error)
            guard error != nil else { return nil }
            guard let ret = output.stringValue else { return nil }
            
            let dates = ret.components(separatedBy: "\r");
            var countsDays:[String:Int] = [:]
            var countsWeeks:[String:Int] = [:]
            var countsMonths:[String:Int] = [:]
            var countsDayOfWeek:[String:Int] = [:]
            
            var countIncomplete = 0
            var countComplete = 0
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .medium
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMM"
            
            let weekdayNames = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            
            let calendar = Calendar.current
        
            let now = (calendar as NSCalendar).components([.weekOfYear, .day, .month, .year], from: Date())
            let nowTime = Date().timeIntervalSince1970;
            
            var sortableTimes : [Double] = []
            
            for item in dates {
                if item == "missing value" {
                    countIncomplete += 1;
                    continue;
                }
                
                if let date = dateFormatter.date(from: item) {
                    countComplete += 1;
                    sortableTimes.append(Double(date.timeIntervalSince1970))
                }
            }
            
            sortableTimes.sort()
            
            for thenTime in sortableTimes {
                let date = Date(timeIntervalSince1970: thenTime)
                let then = calendar.dateComponents([.weekOfYear, .weekday, .day, .month, .year], from: date)
                if then.year == now.year {
                    let weekName = "Week \(then.weekOfYear ?? 0)"
                    
                    countsWeeks[weekName] = (countsWeeks[weekName] ?? 0) + 1
                    
                    if let month = then.month {
                        var monthVal = String(month)
                        if(monthVal.count == 1){
                            monthVal = "0\(monthVal)"
                        }
                        let monthName = "\(monthVal)|\(dateFormatter2.string(from: date))"
                        countsMonths[monthName] = (countsMonths[monthName] ?? 0) + 1
                    }
                }
                
                if thenTime >= nowTime - 7 * 86400 {
                    let daySortValue = then.year!*1000 + then.month!*70 + then.day!
                    let dayName = "\(daySortValue)|\(then.day!)-\(then.month!)"
                    countsDays[dayName] = (countsDays[dayName] ?? 0) + 1
                }
                
                let dayOfWeekName = "\(then.weekday!)|\(weekdayNames[then.weekday!])"
                countsDayOfWeek[dayOfWeekName] = (countsDayOfWeek[dayOfWeekName] ?? 0) + 1
            }
            
            return [
                "days": countsDays,
                "weeks": countsWeeks,
                "months": countsMonths,
                "weekdays": countsDayOfWeek,
                "totals": [
                    "complete": countComplete,
                    "incomplete": countIncomplete
                ]
            ];
        }
        
        return [:];
    }
    
}
