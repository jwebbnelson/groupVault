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
    
    static func createMessage(sender: String, text: String?, photo: String?, dateString: String, viewedBy: [String], completion: (success: Bool) -> Void) {
        
        let messageID = FirebaseController.base.childByAppendingPath("messages").childByAutoId()
        let identifier = messageID.key
        var message = Message(sender: sender, text: text!, photo: photo, dateString: dateString, viewedBy: viewedBy, identifier: identifier)
        message.save()
        completion(success: true)
        
        
        
        
        
       
        
        
    }
    //    static func createMessage(sender: String, text: String?, photo: String?, dateString: String, viewedBy: [String], completion: (success: Bool, message: Messages) -> Void) {
    //
    //        var message = Messages(sender: <#T##String#>, text: <#T##String#>, photo: <#T##String?#>, dateString: <#T##String?#>, viewedBy: <#T##[String]#>, identifier: <#T##String#>)
    //    }
    
    
}
