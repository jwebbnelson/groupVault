//
//  SenderCell.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 4/5/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {
    
    static let sharedCell = SenderCell()
    
    @IBOutlet weak var senderDate: UILabel!
    
    @IBOutlet weak var senderMessageView: UIView!
    
    @IBOutlet weak var senderMessageText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func messageViewForSender(message: Message) {
    senderMessageView.layer.masksToBounds = true
    senderMessageView.layer.cornerRadius = 8.0
    senderMessageView.backgroundColor = UIColor.lightGrayColor()
    senderMessageView.layer.borderColor = UIColor.blackColor().CGColor
    senderMessageView.layer.borderWidth = 0.5
    senderMessageText.textColor = UIColor.blackColor()
    senderMessageText.text = message.text
    senderDate.textColor = Color.lightBlueMessageColor()
    senderDate.text = message.dateString
    senderDate.font = UIFont.boldSystemFontOfSize(12)
        
    }
}

protocol SenderTableViewCellDelegate {
    func senderButtonTapped(sender: SenderCell)
}

extension SenderCell {
    func updateWithMessage(message: Message) {
        print("bitch")
        //HELLO 
}
}