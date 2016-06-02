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
    
    var message: Message?
    
    static let sharedController = MessageController()
    
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
    
    static func fetchMessagesForGroup(group: Group, completion: (messages: [Message]) -> Void) {
        guard let groupID = group.identifier else {completion(messages: []); return}
        
        FirebaseController.base.childByAppendingPath("messages").queryOrderedByChild("group").queryEqualToValue(groupID).observeEventType(.Value, withBlock: { snapshot in
            if let messageDictionaries = snapshot.value as? [String: AnyObject] {
                let message = messageDictionaries.flatMap({Message(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                completion(messages: message)
            } else {
                completion(messages: [])
            }
        })
        
    }
    
    ///THIS HAS BEEN MY BIGGEST ACCOMPLISHMENT IN CODE
    
    static func userViewedMessage(message: Message, completion: (success: Bool, message: Message?) -> Void) {
        
        if let currentUser = UserController.sharedController.currentUser {
            if let viewedBy = message.viewedBy {
                var viewedByArray = viewedBy
                if let currentUserIdentifier = currentUser.identifier {
                    viewedByArray.append(currentUserIdentifier)
                    message.viewedBy = viewedByArray
                }
            }
        }
        let allMessageIDs = FirebaseController.base.childByAppendingPath("messages")
        let specificMessage = allMessageIDs.childByAppendingPath(message.identifier)
        specificMessage.childByAppendingPath("viewedBy").setValue(message.viewedBy)
        
        completion(success: true, message: message)
    }
    
    
    static func createMessage(sender: String, senderName: String, senderImageString: String, groupID: String, text: String?, timer: Timer?, viewedBy: [String], completion: (success: Bool, message: Message) -> Void) {
        
        let messageID = FirebaseController.base.childByAppendingPath("messages").childByAutoId()
        let identifier = messageID.key
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd"
        
        var message = Message(sender: sender, senderName: senderName, senderImageString: senderImageString, text: text, dateString: formatter.stringFromDate(NSDate()), timer: timer, viewedBy: viewedBy, identifier: identifier, groupID: groupID)
        message.save()
        
        
        completion(success: true, message: message)
        
    }
}




