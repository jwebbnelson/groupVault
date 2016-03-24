//
//  Groups.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Groups: FirebaseType {
    
    let kGroupID = "groupID"
    let kGroupName = "groupName"
    let kUsers = "users"
    let kMessages = "messages"
    
    var groupID: String = ""
    var groupName: String
    var users: [String]
    // should I change this to "[User]"
    var messages: [String]
    // same for this one
    
    var identifier: String? // is this the same as the groupID
    var endpoint: String {
        return "Groups"
    }
    
    var jsonValue: [String: AnyObject] {
        return [kGroupID: groupID, kGroupName: groupName, kUsers: users, kMessages: messages]
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        
        guard let groupID = json[kGroupID] as? String,
        let groupName = json[kGroupName] as? String,
        let users = json[kUsers] as? [String],
        let messages = json[kMessages] as? [String] else { return }
        
        self.groupID = groupID
        self.groupName = groupName
        self.users = users
        self.messages = messages
    }
    
    init(groupName: String, users:[User]) {
        self.groupID = ""
        self.groupName = groupName
        self.users = []
        self.messages = []
    }
}

func == (lhs: Groups, rhs: Groups) -> Bool {
    
    return (lhs.groupID == rhs.groupID) && (lhs.identifier == rhs.identifier)
}
