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
            return 0
        }
    }
    
    weak var delegate: TimerDelegate?
    weak var senderDelegate: SenderTimerDelegate?
    
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
        senderDelegate?.updateTimerLabel()
        
        /// the delegate method is searching for the word delegate or the word "updateTimerLabel"
    }
    
    func complete() {
        delegate?.messageTimerComplete()
        senderDelegate?.messageTimerComplete()
    }
    
}

protocol TimerDelegate: class {
    func updateTimerLabel()
    func messageTimerComplete()
}

protocol SenderTimerDelegate: class {
    func updateTimerLabel()
    func messageTimerComplete()
}