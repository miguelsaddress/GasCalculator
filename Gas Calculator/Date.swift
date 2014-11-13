//
//  Date.swift
//  Gas Calculator
//
//  Created by Miguel Angel Moreno Armenteros on 12/11/14.
//  Copyright (c) 2014 Miguel Angel Moreno Armenteros. All rights reserved.
//

import Foundation

class Date {
    
    class func from(#year: Int, month: Int, day: Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        var gregorianCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var date = gregorianCalendar?.dateFromComponents(components);
        
        return date!
    }
    
    class func toString(date: NSDate) -> String {
        return self.toStringWithFormat(date)
    }
    
    class func toStringWithFormat(date: NSDate, format:String = "dd-MM-yyyy") -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
    class func toStringUsingLocale(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
    }
    
    class func daysBetween(fromDate date1:NSDate, toDate date2:NSDate) -> Int {
        let unit:NSCalendarUnit = .DayCalendarUnit

        let calendar = NSCalendar.currentCalendar()
        let components: NSDateComponents = calendar.components(unit, fromDate: date1, toDate: date2, options: nil)
        return abs(components.day)+1
    }

}