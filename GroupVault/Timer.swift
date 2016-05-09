//
//  Timer.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/5/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Timer {
    
    var endDate: NSDate?
    
    var timeRemaining: NSTimeInterval {
        if let endDate = endDate {
            return endDate.timeIntervalSinceNow
        } else {
            return 10
        }
    }
    
    var isOn: Bool {
        if endDate == nil {
            return false
        } else {
            return true
        }
    }
    
    var isComplete: Bool?
}