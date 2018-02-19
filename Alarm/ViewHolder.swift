//
//  MainView.swift
//  Alarm
//
//  Created by Caelan Dailey on 2/6/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//
//
//  Created for CS 4530-002 Spring 2018 Mobile App Programming
//  Project 1 - Alarm
//
// CLOCK DOES WORK IN REAL TIME using timer and Date()

/*
 
ASSIGNMENT DETAILS
Main Composite View - A grouping view which contains the other views. Must inherit from UIView or UIControl and must include public properties to programmatically get and set values for the following properties:
 
Alarm Time - An alarm time represented as a TimeInterval representing seconds since midnight within a single day. Assume all days have exactly 86400 seconds.
 
Alarm Duration - A value expressed as a TimeInterval which represents the number of seconds for which an alarm will sound. Supported values must be between 1 and 120 seconds.
 
Alarm Days - A set of enum values which represents the days of the week on which the alarm will occur.
 
Alarm Time Zone - An enum value indicating which time zone the alarm occurs in.
 */

/*
  This project creates the UI for an alarm
The project requested a custom clock UI and a custom control
 For my clock:
    - Seconds
    - Minutes
    - Hours
    - Realtime
    - Created using CoreGraphics API
    - CoreGraphics label for AM or PM
    - UI Ticks for each second on clock
 
 For my control:
    - Custom UI Slider
 How it works:
    - Moves nib on the x axis where you place your finger in the view
    - Has offsets on the left and right to place it in the center
    - Size of nib is custom
    - Size of bar is custom
    - Bar fills it when moves
 Looks:
    - Has labels on left and right describing the bottom and top limits
    - Has value label on bottom showing CURRENT position
 
 HOW TO IMPROVE:
    All 3 of my duraction, day, and zone controls are the same custom control
    In the future it would be possible to customize the control to where you can edit the labels, size, and outputs, etc.
    To where the slider could look any color and be anysize, etc.
 
 CONCERNS: Maybe for grader too
    Not sure what the point of the GET and SET values are in the Main Composite View
    My labels of the days, time, duration are all in the controls themselves.
 */


import Foundation
import UIKit

class ViewHolder: UIView {
    
    // Private variables
    private var duration: TimeInterval = 0
    private var theTime: TimeInterval = 0
    private var day: alarmDay = .Monday
    private var zone: alarmZone = .AST
    
    enum alarmDay {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
    
    enum alarmZone {
        case AST
        case EST
        case CST
        case MST
        case PST
        case AKST
        case HST
        case UTC11
        case UTC10
    }
    
    // GETTER AND SETTER
    
    var currentDay: alarmDay {
    
        get {
            return day
        } set {
            day = newValue
            
        }
    }
    
    var currentZone: alarmZone {
        get {
            return zone
        }set {
            zone = newValue
        }
        
    }
    
    var alarmDuration: TimeInterval {
        get {
            return duration
        }
        set {
            duration = newValue
        }
    }
    
    var alarmTime: TimeInterval {
        get {
            return theTime
        }
        set {
            theTime = newValue
        }
    }
    
    // Views and Controls
    
    let clockView: ClockView = {
        let clockView = ClockView()
        clockView.translatesAutoresizingMaskIntoConstraints = false
        return clockView
    }()
    
    let timeControl: TimeControl = {
        let timeControl = TimeControl()
        timeControl.translatesAutoresizingMaskIntoConstraints = false
        return timeControl
    }()
    
    let dayControl: DayControl = {
        let dayControl = DayControl()
        dayControl.translatesAutoresizingMaskIntoConstraints = false
        return dayControl
    }()
    
    let durationControl: DurationControl = {
        let durationControl = DurationControl()
        durationControl.translatesAutoresizingMaskIntoConstraints = false
        return durationControl
    }()
    
    let zoneControl: ZoneControl = {
        let zoneControl = ZoneControl()
        zoneControl.translatesAutoresizingMaskIntoConstraints = false
        return zoneControl
    }()
    
    // MODIFY BACKGROUND COLORS
    override var backgroundColor: UIColor? {
        didSet {
            let whiteColor = UIColor(red: 251/256, green: 251/256, blue: 251/256, alpha: 1.0)
            zoneControl.backgroundColor = whiteColor
            dayControl.backgroundColor = whiteColor
            clockView.backgroundColor = UIColor.clear
            durationControl.backgroundColor = whiteColor
            timeControl.backgroundColor = whiteColor
        }
    }
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(zoneControl)
        addSubview(dayControl)
        addSubview(clockView)
        addSubview(durationControl)
        addSubview(timeControl)
        zoneControl.addTarget(self, action: #selector(zoneControlChanged), for: .valueChanged)
        dayControl.addTarget(self, action: #selector(dayControlChanged), for: .valueChanged)
        durationControl.addTarget(self, action: #selector(durationControlChanged), for: .valueChanged)
        timeControl.addTarget(self, action: #selector(timeControlChanged), for: .valueChanged)
    }
    
    // THANKS APPLE
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // CREATE VIEW POSITIONS
    // HOW IT WORKS:
    // if vertical: Put controls below
    // if horizontal: Put controls to the right
    // Adjust cursor based on orientation
    override func layoutSubviews() {
        var cursor: CGPoint = .zero
        var length: CGFloat = 0.0
        var offSet:CGFloat = 0
        var newWidth: CGFloat = 0
        
        
        // If horizontal or verticles
        if bounds.width > bounds.height {
            length = bounds.height
            offSet = bounds.height/10
        } else {
            length = bounds.width
            offSet = bounds.width/10
        }
        
        // CLOCK
        clockView.frame = CGRect(x: offSet, y: offSet, width: length - offSet*2, height: length - offSet*2)
        
        // If horizontal or verticles
        if bounds.width > bounds.height {
            // SHIFT TO THE RIGHT
            cursor.x += bounds.height
            length = (bounds.height)/4
            newWidth = bounds.width - bounds.height
        } else {
            // SHIFT DOWN
            cursor.y += bounds.width
            length = (bounds.height - bounds.width)/4
            newWidth = bounds.width
        }
        
        // CONTROLS
        timeControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        durationControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        dayControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        cursor.y += length
        zoneControl.frame = CGRect(x: cursor.x, y: cursor.y, width: newWidth, height: length)
        
        // Subviews not being reloaded when rotating. need to add these
        zoneControl.setNeedsDisplay()
        timeControl.setNeedsDisplay()
        durationControl.setNeedsDisplay()
    }
    
    
    // ___________________________________________________________________ACTIONS
    
    // GET DURATION VALUE HERE
    // RECIEVED AS INTEGER VALUE BETWEEN 1-120
    @objc func durationControlChanged(sender: DurationControl) {
       alarmDuration = TimeInterval(sender.value)
    }
    
    // GET TIME VALUE HERE
    // POSSIBLE VALUES: 12:00AM - 11:59PM
    // SENT AS A DATE
    @objc func timeControlChanged(sender: UIDatePicker) {
        let date = sender.date
        let c = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        
        if let hour = c.hour, let minute = c.minute, let second = c.second {
            alarmTime = TimeInterval(hour*3600 + minute*60 + second)
        }
    }
    
    // GET DAY VALUE HERE:
    // POSSIBLE VALUES: INTEER FROM 0-6
    @objc func dayControlChanged(sender: DayControl) {
        switch (sender.value) {
        case 0: currentDay = .Monday
        case 1: currentDay = .Tuesday
        case 2: currentDay = .Wednesday
        case 3: currentDay = .Thursday
        case 4: currentDay = .Friday
        case 5: currentDay = .Saturday
        case 6: currentDay = .Sunday
        default: currentDay = .Monday
        }
    }
    
    // GET ZONE VALUE HERE
    // VALUES FROM 0-8 AS AN INTEGER
    @objc func zoneControlChanged(sender: ZoneControl) {
        switch (sender.value) {
        case 0: currentZone = .AST
        case 1: currentZone = .EST
        case 2: currentZone = .CST
        case 3: currentZone = .MST
        case 4: currentZone = .PST
        case 5: currentZone = .AKST
        case 6: currentZone = .HST
        case 7: currentZone = .UTC11
        case 8: currentZone = .UTC10
        default: currentZone = .AST
        }
    }
}
