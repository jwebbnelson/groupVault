//
//  MessagesController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation
import Firebase

class MessageController {
    
    static let sharedController = MessageController()
    
    //    var messages: [Messages] = []
    //    var sender: String = ""
    
    static func messageForIdentifier(identifier: String, completion: (message: Message?) -> Void) {
        
        FirebaseController.dataAtEndpoint("messages/\(identifier)", completion: { (data) in
            if let json = data as? [String: AnyObject] {
                let message = Message(json: json, identifier: identifier)
                completion(message: message)
            } else {
                completion(message: nil)
            }
        })
    }
    
    static func createMessage(sender: String, groupID: String, text: String?, photo: String?, completion: (success: Bool, message: Message) -> Void) {
        
        let messageID = FirebaseController.base.childByAppendingPath("messages").childByAutoId()
        let identifier = messageID.key
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "mm-dd"
        
        var message = Message(sender: sender, text: text, photo: photo, dateString: formatter.stringFromDate(NSDate()), viewedBy: [], identifier: identifier)
        message.save()
        
        self.addMessageIDToGroup(message, groupID: groupID)
        
        completion(success: true, message: message)
        
    }
    
    static func addMessageIDToGroup(message: Message, groupID: String) {
        let allGroups = FirebaseController.base.childByAppendingPath("groups")
        let specificGroup = allGroups.childByAppendingPath(groupID)
        let messageReference = specificGroup.childByAppendingPath("messages")
        let messageIDs = messageReference.childByAppendingPath(message.identifier)
        messageIDs.setValue(message.text ?? message.photo ?? "")
        
        
    }
    
}


