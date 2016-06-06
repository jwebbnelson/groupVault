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









