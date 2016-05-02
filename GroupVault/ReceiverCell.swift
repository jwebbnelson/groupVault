//
//  ReceiverCell.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 4/5/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var recieverDate: UILabel!
    
    @IBOutlet weak var recieverUserName: UILabel!
    
    @IBOutlet weak var recieverMessageView: UIView!

    @IBOutlet weak var recieverMessageText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func messageViewForReceiver(message: Message) {
        
        recieverMessageView.layer.masksToBounds = true
        recieverMessageView.layer.cornerRadius = 8.0
        recieverMessageView.backgroundColor = Color.lightBlueMessageColor()
        recieverMessageView.layer.borderColor = UIColor.blackColor().CGColor
        recieverMessageView.layer.borderWidth = 0.5
        recieverMessageText.textColor = UIColor.blackColor()
        recieverMessageText.text = message.text
        recieverDate.textColor = UIColor.lightGrayColor()
        recieverDate.text = message.dateString
        recieverDate.font = UIFont.boldSystemFontOfSize(12)
        recieverUserName.font = UIFont.boldSystemFontOfSize(12)
        recieverUserName.text = message.senderName
        recieverUserName.font = UIFont.boldSystemFontOfSize(12)
        
    }

}
