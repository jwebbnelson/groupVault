//
//  BuildAGroupTableViewCell.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/20/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class BuildAGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIView!
    
    @IBOutlet weak var userLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
