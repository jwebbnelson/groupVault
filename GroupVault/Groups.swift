//
//  Groups.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Groups {
    
    var groupID: String
    var groupName: String
    var users: [User] = []
    var endpoint: String {
        return "Groups"
    }
    
    init(groupID: String, groupName: String) {
        self.groupID = groupID
        self.groupName = groupName
    }
    
}
