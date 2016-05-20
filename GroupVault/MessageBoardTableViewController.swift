//
//  MessageBoardTableViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class MessageBoardTableViewController: UITableViewController, UITextFieldDelegate {
    
    var group: Group?
    var groupMessages: [Message] = []
    var currentGroup = ""
    var timer: Timer?
    var message: Message?
    let currentUser = UserController.sharedController.currentUser.identifier
    
    
    @IBOutlet weak var groupNameLabelOnMessageBoard: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        scrollToBottom(true)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        let allMessages = groupMessages
        for message in allMessages {
            if message.timer != nil {
                TimerController.sharedInstance.stopTimer(message.timer ?? Timer())
            }
        }
    }
    @IBAction func showMessageButtonTapped(sender: AnyObject) {
        
        
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        self.scrollToLastRow(true)
        if messageTextField.text == "" {
            print("text must be entered in order to send a message")
        } else {
            createMessage()
            messageTextField.text = ""
        }
        
    }
    
    func createMessage() {
        if let message = messageTextField.text, let userIdentifier = UserController.sharedController.currentUser.identifier {
            if let group = group, let identifier = group.identifier {
                MessageController.createMessage(userIdentifier, senderName: UserController.sharedController.currentUser.username, groupID: identifier, text: message, image: "", timer: Timer(), viewedBy: [], completion: { (success, message) in
                    if success == true {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.tableView.reloadData()
                            
                            // think about cell for row at index Path and number of rows in section
                        })
                    } else {
                        print("message not saved")
                    }
                    
                })
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupMessages.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = groupMessages[indexPath.row]
        
        
        if message.sender == self.currentUser {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath) as! SenderCell
            cell.message = message
            if let viewedByArray = message.viewedBy {
                if viewedByArray.contains(message.sender) {
                    cell.lockImageViewForSender()
                } else {
                    TimerController.sharedInstance.startTimer(message.timer ?? Timer())
                    cell.messageViewForSender(message)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("receiverCell", forIndexPath: indexPath) as! ReceiverCell
            cell.delegate = self
            cell.message = message
            
            guard let currentUser = UserController.sharedController.currentUser.identifier,
                viewedByArray = message.viewedBy else { return cell }
            if viewedByArray.contains(currentUser) {
                cell.goBackToLockImageView()
            } else {
                cell.lockImageViewForReceiver()
            }
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    func updateWith(group: Group) {
        self.groupNameLabelOnMessageBoard.text = group.groupName
        self.group = group
        
        MessageController.fetchMessagesForGroup(group) { (messages) in
            if messages.count > self.groupMessages.count {
                self.groupMessages = messages.sort({ $0.identifier < $1.identifier })
                self.tableView.reloadData()
            } else {
                self.groupMessages = messages.sort({ $0.identifier < $1.identifier })
            }
        }
    }
    
    func scrollToBottom(bool: Bool){
        if self.groupMessages.count > 0 {
            let lastRowNumer = self.groupMessages.count - 1
            let indexPath = NSIndexPath(forRow: lastRowNumer, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: bool)
        }
    }
    
    func scrollToLastRow(bool: Bool) {
        let indexPath = NSIndexPath(forRow: self.groupMessages.count - 1, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
}

extension MessageBoardTableViewController: SenderTableViewCellDelegate, RecieverTableViewCellDelegate {
    
    func senderMessageSent(sender: SenderCell) {
        
    }
    
    func receiverLockImagebuttonTapped(sender: ReceiverCell) {
        
        guard let message = sender.message,
            currentUser = self.currentUser,
            viewedByArray = message.viewedBy else { return }
        if viewedByArray.contains(currentUser) {
            sender.goBackToLockImageView()
        } else {
            TimerController.sharedInstance.startTimer(message.timer ?? Timer())
            sender.messageViewForReceiver(message)
        }
    }
}
















