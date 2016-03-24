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
    
    private let kUser = "userKey"
    
    static let sharedController = userController()
    
    var currentUser: User! {
        get {
            guard let userID = FirebaseController.base.authData?.uid,
                let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else {
                    
                    return nil
            }
            
            return User(json: userDictionary, identifier: userID)
        }
        
        set {
            
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            
            if let json = data as? [String: AnyObject] {
                let user = User(json: json, identifier: identifier)
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        
        FirebaseController.dataAtEndpoint("users") { (data) in
            if let json = data as? [String: AnyObject] {
                
                let users = json.flatMap({User})
            }
        }
    }
    
    static func authenticateUser(email: String, password: String, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            
            if error != nil {
                print("Unsuccessful login attempt.")
                completion(success: false, user: nil)
            } else {
                print("User ID: \(response.uid) was successfully authenticated")
                userController.userForIdentifier(response.uid, completion: { (user) -> Void in
                    
                    if let user = user {
                        self.sharedController.currentUser = user
                    }
                    
                    completion(success: true, user: user)
                })
            }
            
        }
    }
    
    static func createUser(email: String, password: String, username: String, completion: (success: Bool, user: User?) -> Void) {
        
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            
            if let userID = response["uid"] as? String {
                var user = User(username: username, groups: [], identifier: userID)
                user.save()
                
                authenticateUser(email, password: password, completion: { (success, user) -> Void in
                    completion(success: success, user: user)
                })
            } else {
                completion(success: false, user: nil)
            }
        }
    }
}










