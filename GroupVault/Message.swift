//
//  Messages.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Message: FirebaseType, Equatable {
    
    let kSender = "sender"
    let kSenderImageString = "senderImageString"
    let kText = "text"
    let kDateString = "dateString"
    let kViewedBy = "viewedBy"
    let kGroupID = "group"
    let kSenderName = "senderName"
    
    
    var sender = ""
    var senderName: String
    var senderImageString: String
    var text: String?
    var dateString: String
    var timer: Timer? = Timer()
    var viewedBy: [String]?
    let groupID: String
    
    var identifier: String?
    var endpoint: String {
        return "messages"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kSender: sender,kSenderName: senderName, kSenderImageString: senderImageString, kDateString: dateString, kGroupID: groupID]
        
        if let text = text {
            json.updateValue(text, forKey: kText)
            
            
            if let viewedBy = viewedBy {
                json.updateValue(viewedBy, forKey: kViewedBy)
            }
        }
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let sender = json[kSender] as? String,
            let senderImageString = json[kSenderImageString] as? String,
            let text = json[kText] as? String,
            let dateString = json[kDateString] as? String,
            let groupID = json[kGroupID] as? String,
            let senderName = json[kSenderName] as? String else { return nil }
        
        self.sender = sender
        self.senderImageString = senderImageString
        self.text = text
        self.dateString = dateString
        self.viewedBy = json[kViewedBy] as? [String] ?? []
        self.groupID = groupID
        self.senderName = senderName
        self.identifier = identifier
    }
    
    init(sender: String, senderName: String, senderImageString: String,text: String?, dateString: String, timer: Timer?, viewedBy: [String], isLocked: Bool = false, identifier: String, groupID: String) {
        self.sender = sender
        self.senderName = senderName
        self.senderImageString = senderImageString
        self.text = text
        self.dateString = dateString
        self.timer = timer
        self.viewedBy = viewedBy
        self.identifier = identifier
        self.groupID = groupID
        
    }
}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.identifier == rhs.identifier
}





