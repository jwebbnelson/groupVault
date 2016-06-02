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
    
     @IBOutlet weak var senderProfileImageView: UIImageView!
    
    @IBOutlet weak var senderMessageView: UIView!
    
<<<<<<< HEAD
    @IBOutlet weak var senderImageView: UIImageView!
    
    @IBOutlet weak var  senderMessageText: UILabel!
=======
    @IBOutlet weak var senderMessageLabel: UILabel!
>>>>>>> 1d6c2729f863378e3e5acc0d33a0ab3768058333
    
    @IBOutlet weak var senderTimerLabel: UILabel!
    
    @IBOutlet weak var senderLockAndUnlockButton: UIButton!
    
    @IBOutlet weak var rightBubbleConstraint: NSLayoutConstraint!
    
    
    weak var delegate: SenderTableViewCellDelegate?
    var message: Message?
    var imageMessage: Image?
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
            senderProfileImageView.hidden = false
            senderLockAndUnlockButton.hidden = false
            senderLockAndUnlockButton.setBackgroundImage(UIImage(named: "unlockedLock"), forState: .Normal)
            ImageController.imageForUser(message.senderImageString) { (success, image) in
                if success {
                    self.senderProfileImageView.image = image
                } else {
                    self.senderProfileImageView.image = UIImage(named: "defaultProfileImage")
                }
            }
            senderMessageView.hidden = true
            senderMessageLabel.hidden = true
            senderDate.textColor = Color.lightBlueMessageColor()
            senderDate.text = message.dateString
            senderDate.font = UIFont.boldSystemFontOfSize(12)
            
        }
    }
    
    func messageViewForSender(message: Message) {
        message.timer?.senderDelegate = self
        senderProfileImageView.hidden = false
        senderMessageView.layer.masksToBounds = true
        senderMessageView.layer.cornerRadius = 8.0
        senderMessageView.backgroundColor = UIColor.lightGrayColor()
        senderMessageView.layer.borderColor = UIColor.blackColor().CGColor
        senderMessageView.layer.borderWidth = 0.5
        senderMessageLabel.textColor = UIColor.blackColor()
        senderMessageLabel.text = message.text
        ImageController.imageForUser(message.senderImageString) { (success, image) in
            if success {
                self.senderProfileImageView.image = image
            } else {
                self.senderProfileImageView.image = UIImage(named: "defaultProfileImage")
            }
        }
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