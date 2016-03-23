//
//  UserController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation
import Firebase

class userController {
    
    func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        
    }
    
    
    func createUser(email: String, password: String, username: String, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            
            if let userID = response["userID"] as? String {
                var user = User(username: username, userID: userID, groups: <#T##[Groups]#>)
                user.save()
                //// the user has to conform to the protocol before it can be saved.
                
                /// what should I do with [groups] here? when the user is created, it doesnt have groups.
                
                
            }
        }
        
    }
}
