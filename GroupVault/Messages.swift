//
//  Messages.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

class Message: FirebaseType {
    
    let kSender = "sender"
    let kText = "text"
    let kPhoto = "photo"
    let kDateString = "dateString"
    let kViewedBy = "viewedBy"
    let kGroupID = "group"
    
    
    var sender = ""
    var text: String?
    var photo: String?
    var dateString: String
    var viewedBy: [String]
    let groupID: String
    
    var identifier: String?
    var endpoint: String {
        return "messages"
    }
    
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kSender: sender, kDateString: dateString, kGroupID: groupID]
        
        if let text = text {
            json.updateValue(text, forKey: kText)
        
        if let photo = photo {
            json.updateValue(photo, forKey: kPhoto)
            
            }
        }
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let sender = json[kSender] as? String,
        let text = json[kText] as? String,
        let dateString = json[kDateString] as? String,
        let groupID = json[kGroupID] as? String else { return nil }
        
        self.sender = sender
        self.text = text
        self.photo = json[kPhoto] as? String
        self.dateString = dateString
        self.viewedBy = json[kViewedBy] as? [String] ?? []
        self.groupID = groupID
    }
    
    init(sender: String, text: String?, photo: String?, dateString: String, viewedBy: [String], identifier: String, groupID: String) {
        self.sender = sender
        self.text = text
        self.photo = photo
        self.dateString = dateString
        self.viewedBy = viewedBy
        self.identifier = identifier
        self.groupID = groupID
    }
    
}





//func timeBomb() {
//    
//    // this is where I want to make the function where the user will only see the text/ image for ten seconds.
//    //Once the ten seconds are up, the text/image will be converted into an image of a lock that has a timestamp.
//    //something that could end up being useful is the firebase function .willChangeValue
//}






