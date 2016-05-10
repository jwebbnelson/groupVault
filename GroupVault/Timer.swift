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
    
    weak var delegate: TimerDelegate?
    
    var isOn: Bool {
        if endDate == nil {
            return false
        } else {
            return true
        }
    }
    
    func timeAsString() -> String {
        let timeRemaining = Int(self.timeRemaining)
        return String(format: "%02d", arguments: [timeRemaining])
    }
    
    func secondTick() {
        delegate?.updateTimerLabel()
    }
    
    func complete() {
        delegate?.messageTimerComplete()
    }
    
}

protocol TimerDelegate: class {
    func updateTimerLabel()
    func messageTimerComplete()
}