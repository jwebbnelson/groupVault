//
//  Messages.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Messages {
    
    
    var user: User
    var messageID: String
    var sender: String
    var text: String?
    var photo: String?
    var dateString: String?
    var viewedBy: [User] = []
    var endpoint: String {
        return "messages"
    }
    
    init(user: User, messageID: String, sender: String) {
        self.user = user
        self.messageID = messageID
        self.sender = sender
    }
    
}
