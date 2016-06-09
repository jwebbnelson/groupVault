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
        print(group.groupImageString)
        
        if let groupImageString = group.groupImageString {
            print(group.groupImageString)
            ImageController.imageForUser(groupImageString) { (success, image) in
                if success {
                    self.groupImageView.image = image
                } else {
                    self.groupImageView.image = UIImage(named: "defaultProfileImage")
                }
            }
        }
        
        self.groupNameLabel.text = group.groupName
        self.group = group
    }
    
}
