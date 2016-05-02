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
    
    enum ViewMode {
        case lockedImage
        case openedMessage
        case unlockedImage
    }
    
    var viewMode = ViewMode.lockedImage
    
//    func updateViewBasedOnMode() {
//        
//        switch viewMode {
//        case .openedMessage:
//            CellMessageTableViewCell.sharedCell.messageTextLabel.hidden = false
//            if let image = CellMessageTableViewCell.sharedCell.imageView?.image {
//                imageView?.hidden = true
//            }
//            CellMessageTableViewCell.sharedCell.leftLabel.hidden = false
//              CellMessageTableViewCell.sharedCell.rightLabel.hidden = false
//            
//        case .lockedImage:
//            CellMessageTableViewCell.sharedCell.messageTextLabel.hidden = true
//        if let image = CellMessageTableViewCell.sharedCell.imageView
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension

    }
    override func viewDidAppear(animated: Bool) {
        
        scrollToBottom()

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
            self.tableView.reloadData()
            scrollToBottom()
            
        }
    }

    
    func scrollToBottom(){
        let indexPath = NSIndexPath(forRow: groupMessages.count - 1, inSection: 0)
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            if self.groupMessages.count >= 1 {
            self.tableView.scrollToRowAtIndexPath((indexPath), atScrollPosition: .Bottom, animated: true)
            }
        })
    }
    
    func createMessage() {
        
        if let message = messageTextField.text, let userIdentifier = UserController.sharedController.currentUser.identifier {
            if let group = group, let identifier = group.identifier {
                
                MessageController.createMessage(userIdentifier, senderName: UserController.sharedController.currentUser.username, groupID: identifier, text: message, photo: "", completion: { (success, message) in
                    if success == true {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.scrollToBottom()
                            self.tableView.reloadData()
                            
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
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("receiverCell", forIndexPath: indexPath) as! ReceiverCell
            
            cell.messageViewForReceiver(message)
            
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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func keyboardConfiguration() {
        
        
    }

}
















