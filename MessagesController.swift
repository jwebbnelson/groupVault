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
    
    static func userViewedMessage(message: Message, completion: (success: Bool) -> Void) {
        let viewedByArray = FirebaseController.base.childByAppendingPath("messages\(message.identifier)").childByAppendingPath("viewedBy")
        let hasViewedBoolean = viewedByArray.key
        
    }
    
    
    static func createMessage(sender: String, senderName: String, groupID: String, text: String?, photo: String?, timer: Timer?, viewedBy: [String] = [], completion: (success: Bool, message: Message) -> Void) {
        
        let messageID = FirebaseController.base.childByAppendingPath("messages").childByAutoId()
        let identifier = messageID.key
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd"
        
        var message = Message(sender: sender, senderName: senderName, text: text, photo: photo, dateString: formatter.stringFromDate(NSDate()), timer: timer, viewedBy: [], identifier: identifier, groupID: groupID)
        message.save()
        
        completion(success: true, message: message)
        
    }
    
    
    
//    static func addMessageIDToGroup(message: Message, groupID: String) {
//        let allGroups = FirebaseController.base.childByAppendingPath("groups")
//        let specificGroup = allGroups.childByAppendingPath(groupID)
//        let messageReference = specificGroup.childByAppendingPath("messages")
//        let messageIDs = messageReference.childByAppendingPath(message.identifier)
//        messageIDs.setValue(message.text ?? message.photo ?? "")
//    }
}




