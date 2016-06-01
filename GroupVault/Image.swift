//
//  Image.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/23/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

//import Foundation
//import UIKit
//
//class Image: FirebaseType, Equatable {
//    
//    let kSender = "sender"
//    var kImage = "image"
//    let kDateString = "dateString"
//    let kViewedBy = "viewedBy"
//    let kGroupID = "group"
//    let kSenderName = "senderName"
//    
//    
//    var sender = ""
//    var senderName: String
//    let groupID: String
//    var image: UIImage?
//    var dateString: String
//    var timer: Timer? = Timer()
//    var viewedBy: [String]?
//    
//    var identifier: String?
//    var endpoint: String {
//        return "images"
//    }
//    
//    var jsonValue: [String: AnyObject] {
//        var json: [String: AnyObject] = [kSender: sender,kSenderName: senderName, kDateString: dateString, kGroupID: groupID]
//        
//        if let image = image?.base64String {
//            json.updateValue(image, forKey: kImage)
//            
//            
//            if let viewedBy = viewedBy {
//                json.updateValue(viewedBy, forKey: kViewedBy)
//            }
//        }
//        return json
//    }
//    
//    required init?(json: [String: AnyObject], identifier: String) {
//        
//        guard let sender = json[kSender] as? String,
//            let image = json[kImage] as? String,
//            let dateString = json[kDateString] as? String,
//            let groupID = json[kGroupID] as? String,
//            let senderName = json[kSenderName] as? String else { return nil }
//        
//        self.sender = sender
//        self.image = UIImage(base64: image)
//        self.dateString = dateString
//        self.viewedBy = json[kViewedBy] as? [String] ?? []
//        self.groupID = groupID
//        self.senderName = senderName
//        self.identifier = identifier
//    }
//    
//    init(sender: String, senderName: String, groupID: String, image: UIImage, dateString: String, timer: Timer?, viewedBy: [String], identifier: String) {
//        self.sender = sender
//        self.senderName = senderName
//        self.groupID = groupID
//        self.image = image
//        self.dateString = dateString
//        self.timer = timer
//        self.viewedBy = viewedBy
//        self.identifier = identifier
//    }
//}
//
//func ==(lhs: Image, rhs: Image) -> Bool {
//    return lhs.identifier == rhs.identifier
//}