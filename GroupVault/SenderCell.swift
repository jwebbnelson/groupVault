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
    
    @IBOutlet weak var senderMessageText: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var unlockButton: UIButton!
    
    weak var delegate: SenderTableViewCellDelegate?
    var message: Message?
    var timer: Timer?
    var isLocked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func lockImageViewForSender() {
        if let message = self.message {
            timerLabel.hidden = true
            unlockButton.hidden = false
            unlockButton.setBackgroundImage(UIImage(named: "unlockedLock"), forState: .Normal)
            senderMessageView.hidden = true
            senderMessageText.hidden = true
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
        senderMessageText.textColor = UIColor.blackColor()
        senderMessageText.text = message.text
        senderDate.textColor = Color.lightBlueMessageColor()
        senderDate.text = message.dateString
        senderDate.font = UIFont.boldSystemFontOfSize(12)
        
    }
    
    func messageTimerComplete() {
        lockImageViewForSender()
    }
    
    func updateTimerLabel() {
        timerLabel.text = message?.timer?.timeAsString()
    }
}

protocol SenderTableViewCellDelegate: class {
    func senderMessageSent(sender: SenderCell)
}

extension SenderCell {
    func updateWithMessage(message: Message) {
        
    }
}