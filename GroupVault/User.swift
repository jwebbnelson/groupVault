//
//  User.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class User {
    
    
    
    var username: String
    var userID: String
    var groups: [Groups]
    var endpoint: String {
        return "users"
    }
    
    init(username: String, userID: String, groups: [Groups]) {
            self.username = username
            self.userID = userID
            self.groups = groups
        }
    func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        
    }
    
    
    func createUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (error, _, result) -> Void in
            
            if error != nil {
                completion(success: false, user: nil)
                print("there was an error creating your account. Please Try again later.")
                
            } else {
                if let uID = result["uid"] as? String {
                    userForIdentifier(uID, completion: { (user) -> Void in
                        completion(success: true, user: user)
                    })
                }
            }
        }
    }

}


