//
//  ImageController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/18/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.


import Foundation
import UIKit
import Firebase

class ImageController {
    
    static var image: Message?
    
    static let sharedController = ImageController()
    
//    static func imageForIdentifier(identifier: String, completion: (image: Message?) -> Void) {
//        
//        FirebaseController.dataAtEndpoint("messages/\(identifier)", completion: { (data) in
//            if let json = data as? [String: AnyObject] {
//                let image = Message(json: json, identifier: identifier)
//                completion(image: image)
//            } else {
//                completion(image: nil)
//            }
//        })
//    }
//    
////    static func fetchImagesForGroup(group: Group, completion: (images: [Message]) -> Void) {
////        guard let groupID = group.identifier else {completion(images: []); return}
////        
////        FirebaseController.base.childByAppendingPath("messages").queryOrderedByChild("group").queryEqualToValue(groupID).observeEventType(.Value, withBlock: { snapshot in
////            if let imageDictionaries = snapshot.value as? [String: AnyObject] {
////                let image = imageDictionaries.flatMap({Message(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
////                completion(images: image)
////            } else {
////                completion(images: [])
////            }
////        })
////        
////    }
//    
//    ///THIS HAS BEEN MY BIGGEST ACCOMPLISHMENT IN CODE
//    
//    static func userViewedImage(image: Message, completion: (success: Bool, image: Message?) -> Void) {
//        
//        if let currentUser = UserController.sharedController.currentUser {
//            if let viewedBy = image.viewedBy {
//                var viewedByArray = viewedBy
//                if let currentUserIdentifier = currentUser.identifier {
//                    viewedByArray.append(currentUserIdentifier)
//                    image.viewedBy = viewedByArray
//                }
//            }
//        }
//        let allImageIDs = FirebaseController.base.childByAppendingPath("images")
//        let specificMessage = allImageIDs.childByAppendingPath(image.identifier)
//        specificMessage.childByAppendingPath("viewedBy").setValue(image.viewedBy)
//        
//        completion(success: true, image: image)
//    }
//    
//    
//    static func uploadGroupMessageImage(sender: String, senderName: String, groupID: String, image: UIImage,timer: Timer?, viewedBy: [String], completion: (success: Bool, image: Message) -> Void) {
//        
//        let imageID = FirebaseController.base.childByAppendingPath("images").childByAutoId()
//        let identifier = imageID.key
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "Mm-dd"
//        
//        var image = Message(sender: sender, senderName: senderName, senderProfileImage: <#T##String#>, text: <#T##String?#>, image: <#T##UIImage?#>, dateString: <#T##String#>, timer: <#T##Timer?#>, viewedBy: <#T##[String]#>, identifier: <#T##String#>, groupID: <#T##String#>)
////            Message(sender: sender, senderName: senderName, groupID: groupID, image: image, dateString: formatter.stringFromDate(NSDate()), timer: timer, viewedBy: viewedBy, identifier: identifier)
//        image.save()
//        
//        completion(success: true, image: image)
//    }
    
    static func uploadProfileImage(user: User, image: UIImage, completion: (identifier: String?) -> Void) {
        
        let user = user
        if let base64Image = image.base64String {
            FirebaseController.base.childByAppendingPath("users/\(user.identifier!)/image").setValue(base64Image)
            user.imageString = base64Image
            UserController.sharedController.currentUser = user
            completion(identifier: base64Image)
        } else {
            completion(identifier: nil)
        }
    }
    
    static func imageForUser(imageString: String, completion: (success: Bool, image: UIImage?) -> Void) {
        
        
        if let image = UIImage(base64: imageString) {
            completion(success: true, image: image)
        } else {
            completion(success: false, image: nil)
        }
        
    }
}









