//
//  GroupsController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation
import Firebase

class groupsController {
    
    static let sharedController = groupsController()
    
    static func groupForIdentifier(identifier: String, completion: (group: Groups?) -> Void) {
        
        FirebaseController.dataAtEndpoint("groups/\(identifier)", completion: { (data) in
            if let data = data as? [String: AnyObject] {
                let group = Groups(json: data, identifier: identifier)
                completion(group: group)
            } else {
                completion(group: nil)
            }
        })
    }
    
    static func createGroup(groupName: String, users: [String], completion: (success: Bool) -> Void) {
        let groupID = FirebaseController.base.childByAppendingPath("groups").childByAutoId()
        let identifier = groupID.key
        var group = Groups(groupName: groupName, users: users, identifier: identifier)
        group.save()
        completion(success: true)
    }
}