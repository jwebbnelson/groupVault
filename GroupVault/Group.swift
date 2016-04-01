//
//  Groups.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Group: Equatable, FirebaseType {
    
    let kGroupName = "groupName"
    let kUsers = "users"
    let kMessages = "messages"
    
    var groupName: String
    var users: [String]
    var messages: [String]
    
    var identifier: String? // is this the same as the groupID
    var endpoint: String {
        return "groups"
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        
        guard let groupName = json[kGroupName] as? String,
            let users = json[kUsers] as? [String] else { return nil }
        
        self.groupName = groupName
        self.users = users
        if let messages = json[kMessages] as? [String] {
            self.messages = messages
        } else {
            self.messages = []
        }
        self.identifier = identifier
    }
    
    init(groupName: String, users:[String], identifier: String) {
        
        self.groupName = groupName
        self.users = users
        self.identifier = identifier
        self.messages = []
    }
    
    var jsonValue: [String: AnyObject] {
        return [kGroupName: groupName, kUsers: users, kMessages: messages]
    }
    
    
}

func == (lhs: Group, rhs: Group) -> Bool {
    
    return (lhs.identifier == rhs.identifier)
}
