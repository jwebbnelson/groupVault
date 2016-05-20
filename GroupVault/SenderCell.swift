//
//  SenderCell.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 4/5/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell, SenderTimerDelegate {
    
    static let sharedCell = SenderCell()
    
    @IBOutlet weak var senderDate: UILabel!
    
    @IBOutlet weak var senderMessageView: UIView!
    
    @IBOutlet weak var senderMessageLabel: UILabel!
    
    @IBOutlet weak var senderTimerLabel: UILabel!
    
    @IBOutlet weak var senderLockAndUnlockButton: UIButton!
    
    @IBOutlet weak var rightBubbleConstraint: NSLayoutConstraint!
    
    weak var delegate: SenderTableViewCellDelegate?
    var message: Message?
    var timer: Timer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func lockImageViewForSender() {
        if let message = self.message {
            senderTimerLabel.hidden = true
            senderLockAndUnlockButton.hidden = false
            senderLockAndUnlockButton.setBackgroundImage(UIImage(named: "unlockedLock"), forState: .Normal)
            senderMessageView.hidden = true
            senderMessageLabel.hidden = true
            senderDate.textColor = Color.lightBlueMessageColor()
            senderDate.text = message.dateString
            senderDate.font = UIFont.boldSystemFontOfSize(12)
            
        }
    }
    
    func messageViewForSender(message: Message) {
        message.timer?.senderDelegate = self
        senderMessageView.layer.masksToBounds = true
        senderMessageView.layer.cornerRadius = 8.0
        senderMessageView.backgroundColor = UIColor.lightGrayColor()
        senderMessageView.layer.borderColor = UIColor.blackColor().CGColor
        senderMessageView.layer.borderWidth = 0.5
        senderMessageLabel.textColor = UIColor.blackColor()
        senderMessageLabel.text = message.text
        senderDate.textColor = Color.lightBlueMessageColor()
        senderDate.text = message.dateString
        senderDate.font = UIFont.boldSystemFontOfSize(12)
        
    }
    
    func messageTimerComplete() {
        lockImageViewForSender()
        message?.viewedBy?.append(UserController.sharedController.currentUser.identifier!)
        message?.save()
        
        // if the user logs out as a timer is going, the timer crashes.
    }
    
    func updateTimerLabel() {
        senderTimerLabel.text = message?.timer?.timeAsString()
    }
}

protocol SenderTableViewCellDelegate: class {
    func senderMessageSent(sender: SenderCell)
}

extension SenderCell {
    func updateWithMessage(message: Message) {
        
    }
}