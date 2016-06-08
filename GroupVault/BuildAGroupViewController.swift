//
//  ViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class BuildAGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewCell: UITableViewCell!
    
    @IBOutlet weak var blurryView: UIView!
    
    @IBOutlet weak var fetchAllUsersIndicator: UIActivityIndicatorView!
    
    
    var usersDataSource: [User] = []
    var filteredDataSource: [User] = []
    var selectedUserIDs: [String] = []
    var currentUser = UserController.sharedController.currentUser
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blurryView.hidden = true
        self.fetchAllUsersIndicator.hidesWhenStopped = true
        self.fetchAllUsersIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        self.startFetchingDataIndicator()
        UserController.fetchAllUsers { (success, users) in
            if success == true {
                self.usersDataSource = users.filter({ (user) -> Bool in
                    return user.identifier != UserController.sharedController.currentUser.identifier
                })
                self.stopFetchingDataIndicator()
                self.tableView.reloadData()
            }
            self.downSwipeGesture()
            self.upSwipeGesture()
            self.tableView.keyboardDismissMode = .OnDrag
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        createGroup()
        print(selectedUserIDs.count)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if filteredDataSource.count > 0 {
            return filteredDataSource.count
        } else {
            return usersDataSource.count
        }
        /// return the number of users
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! BuildAGroupTableViewCell
        
        cell.delegate = self
        
        let user = usersDataSource[indexPath.row]
        
        cell.userViewOnCell(user)
        
        let selectedForGroup = user.selectedForGroup
        
        if selectedForGroup == true {
            cell.userSelectedForGroup(user)
            
        } else if selectedForGroup == false {
            cell.userNotSelectedForGroup(user)
        }
        
        
        //        let user = filteredDataSource.count > 0 ? filteredDataSource[indexPath.row]:usersDataSource[indexPath.row]
        //
        //        cell.userLabel.text = user.username
        //        if let userImageString = user.imageString {
        //            ImageController.imageForUser(userImageString) { (success, image) in
        //                if success {
        //                    cell.userProfileImageView.image = image
        //                } else {
        //                    cell.userProfileImageView.image = UIImage(named: "defaultProfileImage")
        //                }
        //            }
        //        }
        
        return cell
    }
    //// self.tableview.rowHeight = UITableView UITableViewAutomaticDimension
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //
    //        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? BuildAGroupTableViewCell{
    //
    //            let user = filteredDataSource.count > 0 ? filteredDataSource[indexPath.row]:usersDataSource[indexPath.row]
    //
    //            if selectedUserIDs.contains(user.identifier!) {
    //
    //                if let index = selectedUserIDs.indexOf(user.identifier!) {
    //
    //                    selectedUserIDs.removeAtIndex(index)
    //
    //                    cell.backgroundColor = UIColor.whiteColor()
    //                }
    //
    //            } else {
    //                selectedUserIDs.append(user.identifier!)
    //
    //                cell.backgroundColor = UIColor.lightGrayColor()
    //
    //            }
    //
    //            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //        }
    //
    //    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    
    
    func createGroup() {
        
        guard let myIdentifier = UserController.sharedController.currentUser.identifier else { return }
        
        for user in usersDataSource {
            if user.selectedForGroup == true {
                selectedUserIDs.append(user.identifier!)
            }
        }
        
        print(selectedUserIDs.count)
        
        if !selectedUserIDs.contains(myIdentifier) {
            selectedUserIDs.append(myIdentifier)
        }
        
        print(selectedUserIDs.count)
        
        if groupNameTextField.text == "" || selectedUserIDs.count <= 1 {
            self.showAlert("Error!", message: "Make sure you create a group name and add members.")
            selectedUserIDs = []
        } else {
            GroupController.createGroup(groupNameTextField.text!, users: selectedUserIDs, completion: { (success, group) in
                
                if (success != nil) {
                    GroupController.passGroupIDsToUsers(self.selectedUserIDs, group:group, key: success!)
                }
            })
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func downSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.swiped))
        swipeDown.direction = .Down
        self.view.addGestureRecognizer(swipeDown)
    }
    func upSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.swiped)
        )
        swipeUp.direction = .Up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    func swiped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Down:
            groupNameTextField.resignFirstResponder()
        case UISwipeGestureRecognizerDirection.Up:
            groupNameTextField.resignFirstResponder()
        default:
            break
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        groupNameTextField.resignFirstResponder()
        return true
    }
    
    func startFetchingDataIndicator() {
        self.blurryView.hidden = false
        self.fetchAllUsersIndicator.startAnimating()
        
        
    }
    
    func stopFetchingDataIndicator() {
        self.blurryView.hidden = true
        self.fetchAllUsersIndicator.stopAnimating()
    }
    
}

extension BuildAGroupViewController: BuildAGroupTableViewCellDelegate {
    
    
    
    func addUserButtonTapped(sender: BuildAGroupTableViewCell) {
        
        let indexPath = tableView.indexPathForCell(sender)
        
        let user = userStatus(indexPath!)
        
        user.selectedForGroup = !user.selectedForGroup
        
        print(user.username)
        print(user.selectedForGroup)
        
        tableView.reloadData()
        
    }
    
    func userStatus(indexPath: NSIndexPath) -> User {
        
        return usersDataSource[indexPath.row]
        
        
    }
    
    
    //        let user = filteredDataSource.count > 0 ? filteredDataSource[indexPath.row]:usersDataSource[indexPath.row]
    //
    //        if selectedUserIDs.contains(user.identifier!) {
    //
    //            if let index = selectedUserIDs.indexOf(user.identifier!) {
    //
    //                selectedUserIDs.removeAtIndex(index)
    //
    //            }
    //
    //        } else {
    //            selectedUserIDs.append(user.identifier!)
    //
    //        }
    //        return self.usersDataSource[indexPath.row]
    //    }
    
}











