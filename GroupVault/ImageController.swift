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
    
    static var image: Image?
    
    static let sharedController = ImageController()
    
    static func imageForIdentifier(identifier: String, completion: (image: Image?) -> Void) {
        
        FirebaseController.dataAtEndpoint("images/\(identifier)", completion: { (data) in
            if let json = data as? [String: AnyObject] {
                let image = Image(json: json, identifier: identifier)
                completion(image: image)
            } else {
                completion(image: nil)
            }
        })
    }
    
    static func fetchImagesForGroup(group: Group, completion: (images: [Image]) -> Void) {
        guard let groupID = group.identifier else {completion(images: []); return}
        
        FirebaseController.base.childByAppendingPath("images").queryOrderedByChild("group").queryEqualToValue(groupID).observeEventType(.Value, withBlock: { snapshot in
            if let imageDictionaries = snapshot.value as? [String: AnyObject] {
                let image = imageDictionaries.flatMap({Image(json: $0.1 as! [String: AnyObject], identifier: $0.0)})
                completion(images: image)
            } else {
                completion(images: [])
            }
        })
        
    }
    
    ///THIS HAS BEEN MY BIGGEST ACCOMPLISHMENT IN CODE
    
    static func userViewedImage(image: Image, completion: (success: Bool, image: Image?) -> Void) {
        
        if let currentUser = UserController.sharedController.currentUser {
            if let viewedBy = image.viewedBy {
                var viewedByArray = viewedBy
                if let currentUserIdentifier = currentUser.identifier {
                    viewedByArray.append(currentUserIdentifier)
                    image.viewedBy = viewedByArray
                }
            }
        }
        let allImageIDs = FirebaseController.base.childByAppendingPath("images")
        let specificMessage = allImageIDs.childByAppendingPath(image.identifier)
        specificMessage.childByAppendingPath("viewedBy").setValue(image.viewedBy)
        
        completion(success: true, image: image)
    }
    
    
    static func uploadGroupMessageImage(sender: String, senderName: String, groupID: String, image: UIImage,timer: Timer?, viewedBy: [String], completion: (success: Bool, image: Image) -> Void) {
        
        let imageID = FirebaseController.base.childByAppendingPath("images").childByAutoId()
        let identifier = imageID.key
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "Mm-dd"
        
        var image = Image(sender: sender, senderName: senderName, groupID: groupID, image: image, dateString: formatter.stringFromDate(NSDate()), timer: timer, viewedBy: viewedBy, identifier: identifier)
        image.save()
        
        completion(success: true, image: image)
    }
    
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









