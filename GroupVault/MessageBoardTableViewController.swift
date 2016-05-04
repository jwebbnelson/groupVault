//
//  MessageBoardTableViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class MessageBoardTableViewController: UITableViewController {
    
    var group: Group?
    var groupMessages: [Message] = []
    var currentGroup = ""
    let currentUser = UserController.sharedController.currentUser.identifier
    
    
    @IBOutlet weak var groupNameLabelOnMessageBoard: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        let presentedTextField = UITextField()
        
        messageTextField.inputAccessoryView = presentedTextField
    }
    override func viewDidAppear(animated: Bool) {
        
        scrollToBottom(true)
        
    }

    
    override func viewWillAppear(animated: Bool) {
        //        let indexPath = NSIndexPath(forRow: groupMessages.count - 1, inSection: 0)
        //        self.tableView.scrollToRowAtIndexPath((indexPath), atScrollPosition: .Bottom, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        
        if messageTextField.text == "" {
            print("text must be entered in order to send a message")
        } else {
            createMessage()
            messageTextField.text = ""
        }
    }
    
    
    func scrollToBottom(bool: Bool){
        if self.groupMessages.count > 0 {
            let lastRowNumer = self.groupMessages.count - 1
            let indexPath = NSIndexPath(forRow: lastRowNumer, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: bool)
        }
    }
    
    func createMessage() {
        
        if let message = messageTextField.text, let userIdentifier = UserController.sharedController.currentUser.identifier {
            if let group = group, let identifier = group.identifier {
                
                MessageController.createMessage(userIdentifier, senderName: UserController.sharedController.currentUser.username, groupID: identifier, text: message, photo: "", completion: { (success, message) in
                    if success == true {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.scrollToBottom(true)
                            self.tableView.reloadData()
                            print("this should be working")
                            
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
            
            cell.messageViewForSender(message)
            cell.delegate = self
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("receiverCell", forIndexPath: indexPath) as! ReceiverCell
            
            cell.messageViewForReceiver(message)
            cell.delegate = self
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
            self.groupMessages = messages.sort({ $0.identifier < $1.identifier })
            self.tableView.reloadData()
        }
    }
    /*
     func showAlert(title: String, message: String) {
     
     let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
     let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
     alert.addAction(action)
     presentViewController(alert, animated: true, completion: nil)
     }
     */
    
}

extension MessageBoardTableViewController: SenderTableViewCellDelegate, RecieverTableViewCellDelegate {
    
    func senderButtonTapped(sender: SenderCell) {
        
        if let indexPath = tableView.indexPathForCell(sender) {
            
            let message = groupMessages[indexPath.row]
            
            message.text = "is this working"
            tableView.reloadData()
        }
        
    }
    
    func receiverCellbuttonTapped(sender: ReceiverCell) {
        
        if let indexPath = tableView.indexPathForCell(sender) {
            
            let message = groupMessages[indexPath.row]
            
            message.text = "this is working"
            tableView.reloadData()
        }
    }
}
















