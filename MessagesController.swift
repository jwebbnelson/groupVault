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
    
    static func fetchGroupMessagesForUser(user: User, completion: (messages: [Message]) -> Void) {
        
        
    }
    
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
    
//    static func observeMessagesForGroup(identifier: String, completion: (message: [Message]) -> Void) {
//        FirebaseController.dataAtEndpoint("groups/\(identifier)/messages") { (data) -> Void in
//            if let messageIdentifierDictionary = data as? [String: AnyObject] {
//                var messages: [Message] = []
//                let tunnel = dispatch_group_create()
//                for identifier in messageIdentifierDictionary.keys {
//                    dispatch_group_enter(tunnel)
//                    MessageController.messageForIdentifier(identifier, completion: { (message) in
//                        if let message = message {
//                            messages.append(message)
//                        }
//                        dispatch_group_leave(tunnel)
//                    })
//                }
//                dispatch_group_notify(tunnel, dispatch_get_main_queue(),  { () -> Void in
//                    completion(message: messages)
//                })
//            } else {
//                completion(message: [])
//            }
//        }
//    }
    
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

    
    static func createMessage(sender: String, groupID: String, text: String?, photo: String?, completion: (success: Bool, message: Message) -> Void) {
        
        let messageID = FirebaseController.base.childByAppendingPath("messages").childByAutoId()
        let identifier = messageID.key
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "mm-dd"
        
        var message = Message(sender: sender, text: text, photo: photo, dateString: formatter.stringFromDate(NSDate()), viewedBy: [], identifier: identifier, groupID: groupID)
        message.save()
        
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


