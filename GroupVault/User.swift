//
//  User.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//




//////MAKE EVERYTHING CONFORM TO THE FIREBASE TYPE. ADD THE PROTOCOLS WHICH I CREATED. THE EXTENSION ON FIREBASE IS SAYING "IF IT CONFORMS TO THE PROTOCOL, THEn THE EXTENSION WILL ALLOW SAVING, AND DELETING."

import Foundation
import Firebase

class User: Equatable, FirebaseType {
    
    let kUsername = "username"
    let kGroups = "groups"
    
    
    var username = ""
    var groups: [String]
    
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    
    var jsonValue: [String: AnyObject] {
        
        return [kUsername: username, kGroups: groups]
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let username = json[kUsername] as? String ,
        let groups = json[kGroups] as? [String] else { return nil }
        
        self.username = username
        self.groups = groups
        self.identifier = identifier
        
    }
    
    init(username: String, groups: [String], identifier: String) {
        self.username = username
        self.groups = []
        self.identifier = identifier
    }
}

func == (lhs: User, rhs: User)-> Bool {
    
    return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
}


///Right now I am trying to figure out how to set up my jsonDictionaries so that they can be displayed in firebase. my main problem is trying to figue out how to add optionals to the jsonDictionary variable.


