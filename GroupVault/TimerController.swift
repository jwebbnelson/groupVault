//
//  TimerController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/8/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation


import Foundation
import UIKit

class TimerController: NSObject {
    
    static let sharedInstance = TimerController()
    
    var timer = Timer()
    var localNotification: UILocalNotification?
    
    
    func startTimer() {
        
        if timer.isOn == false {
            timer.endDate = NSDate(timeIntervalSinceNow: 10)
            secondTick()
            scheduleLocalNotification()
            
        }
    }
    
    func stopTimer() {
        if timer.isOn {
            timer.endDate = nil
            performSelector(#selector(TimerController.cancelLocalNotification), withObject: nil, afterDelay: 0.5)
            
        }
    }
    
    func secondTick() {
        if timer.timeRemaining > 0 {
            performSelector(#selector(TimerController.secondTick), withObject: nil, afterDelay: 1)
            NSNotificationCenter.defaultCenter().postNotificationName("secondTick", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("timerCompleted", object: nil)
            stopTimer()
            timer.isComplete = true
        }
    }
    
    func scheduleLocalNotification() {
        
        localNotification = UILocalNotification()
        localNotification?.alertBody = "It's time to wake up"
        localNotification?.alertTitle = "Time's up!"
        localNotification?.fireDate = timer.endDate
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification ?? UILocalNotification())
        
    }
    
    func cancelLocalNotification() {
        UIApplication.sharedApplication().cancelLocalNotification(localNotification ?? UILocalNotification())
    }
    
    func timeAsString() -> String {
        
        let timeRemaining = Int(timer.timeRemaining)
        return String(format: "%02d", arguments: [timeRemaining])
    }
}