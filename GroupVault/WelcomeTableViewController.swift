//
//  WelcomeTableViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit
import Firebase

class WelcomeTableViewController: UITableViewController {
    
    static let sharedController = WelcomeTableViewController()
    var groups: [Group] = []
    var currentUser = ""
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.sharedController.currentUser{
            currentUser = user.identifier!
        }else{
            performSegueWithIdentifier("noUserLoggedIn", sender: nil)
        }
        
        if FirebaseController.base.authData == nil {
            
            performSegueWithIdentifier("noUserLoggedIn", sender: nil)
        }
        
        welcomeLabelForUser()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        UserController.observeGroupsForUser(currentUser) { (group) in
            self.groups = group
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutButtonTapped(sender: AnyObject) {
        FirebaseController.base.unauth()
        performSegueWithIdentifier("noUserLoggedIn", sender: nil)
    }
    
    func welcomeLabelForUser() {
        if UserController.sharedController.currentUser != nil {
        welcomeLabel.text = "Welcome, \(UserController.sharedController.currentUser.username)!"
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groups.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("enterAGroup", forIndexPath: indexPath)
        
        let group = self.groups[indexPath.row]
        
        cell.textLabel?.text = group.groupName
        
        return cell
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "enterAGroup"{
            
            let messageBoardTableViewController = segue.destinationViewController as? MessageBoardTableViewController
            
            _ = messageBoardTableViewController!.view
            
            let indexPath = tableView.indexPathForSelectedRow
            
            if let selectedRow = indexPath?.row {
                
                let group = self.groups[selectedRow]
                messageBoardTableViewController?.updateWith(group)
                
                
            }
            
        }
        
        
    }
}