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
        
        updateBasedOnGroup()
        
        }
    
    override func viewWillAppear(animated: Bool) {
        
        guard let group = group  else { return }
        MessageController.fetchMessagesForGroup(group) { (messages) in
            self.groupMessages = messages
            self.tableView.reloadData()
            }
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
    
    func updateBasedOnGroup() {
        guard let group = group else { return }
        
        MessageController.fetchMessagesForGroup(group) { (messages) -> Void in
            self.groupMessages = messages
        }
    }
    
    func createMessage() {
        
        if let message = messageTextField.text, let userIdentifier = UserController.sharedController.currentUser.identifier {
            if let group = group, let identifier = group.identifier {
            
                MessageController.createMessage(userIdentifier, senderName: UserController.sharedController.currentUser.username, groupID: identifier, text: message, photo: "", completion: { (success, message) in
                if success == true {
                    dispatch_async(dispatch_get_main_queue(), {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMessage", forIndexPath: indexPath) as! CellMessageTableViewCell

        let message = groupMessages[indexPath.row]
        
        cell.messageTextLabel.text = message.text

        if message.sender == self.currentUser {
            
            cell.messageTextLabel.textAlignment = NSTextAlignment.Right
            cell.rightLabel.text = message.senderName
            cell.rightLabel.textColor = UIColor.blackColor()
            cell.rightLabel.font = UIFont.boldSystemFontOfSize(20)
            cell.leftLabel.text = message.dateString
            cell.leftLabel.font = UIFont.boldSystemFontOfSize(12)
            cell.leftLabel.textColor = UIColor.lightGrayColor()
        } else {
            cell.messageTextLabel.textAlignment = NSTextAlignment.Left
            cell.leftLabel.text = message.senderName
            cell.leftLabel.font = UIFont.boldSystemFontOfSize(20)
            cell.leftLabel.textColor = UIColor.blackColor()
            cell.rightLabel.text = message.dateString
            cell.rightLabel.font = UIFont.boldSystemFontOfSize(12)
            cell.rightLabel.textColor = UIColor.lightGrayColor()
        }

        return cell
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
    }

}
















