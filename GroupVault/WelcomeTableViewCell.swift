//
//  WelcomeTableViewCell.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 6/8/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class WelcomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var group: Group?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func groupViewOnCell(group: Group) {
        if let groupID = group.identifier {
            ImageController.groupImageForIdentifier(groupID, completion: { (image) in
                if let groupImage = image {
                    self.groupImageView.image = groupImage
                } else {
                    self.groupImageView.image = UIImage(named: "defaultProfileImage")
                }
            })
            
            
        
        }
        
        self.groupNameLabel.text = group.groupName
        self.group = group
    }
    
    //static func imageForGroup(group: Group, completion: (image: UIImage?) -> Void) {
    //
    //    FirebaseController.dataAtEndpoint("groups/\(group.identifier)/image") { (data) -> Void in
    //
    //        if let data = data as? String {
    //            let image = UIImage(base64: data)
    //            completion(image: image)
    //        } else {
    //            completion(image: nil)
    //        }
    //    }
    //}
    
    //            FirebaseController.dataAtEndpoint("groups/\(groupID)/images") { (data) -> Void in
    //
    //                if let data = data as? String {
    //                    let image = UIImage(base64: data)
    //                    completion(image: image)
    //                } else {
    //                    completion(image: nil)
    //                }
    //            }
    //
    
}
