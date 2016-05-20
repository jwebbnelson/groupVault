//
//  Build2File.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/20/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import Foundation

//class BuildAGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
//    
//    
//    @IBOutlet weak var groupNameTextField: UITextField!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    @IBOutlet weak var tableViewCell: UITableViewCell!
//    
//    var usersDataSource: [User] = []
//    var filteredDataSource: [User] = []
//    var selectedUserIDs: [String] = []
//    var currentUser = UserController.sharedController.currentUser
//    var user: User!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        UserController.fetchAllUsers { (users) in
//            self.usersDataSource = users.filter({ (user) -> Bool in
//                return user.identifier != UserController.sharedController.currentUser.identifier
//            })
//            
//            
//            print(users.count)
//            dispatch_async(dispatch_get_main_queue(), {
//                self.tableView.reloadData()
//            })
//        }
//        tableView.reloadData()
//        groupNameTextField.delegate = self
//        
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func saveButtonTapped(sender: AnyObject) {
//        
//        if groupNameTextField.text == "" || selectedUserIDs == [] {
//            self.showAlert("Error!", message: "Make sure you create a group name and add members.")
//            
//        } else {
//            createGroup()
//            navigationController?.popViewControllerAnimated(true)
//        }
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.filteredDataSource = self.usersDataSource.filter({$0.username.containsString(searchText.lowercaseString)})
//            
//            self.tableView.reloadData()
//        }
//    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        groupNameTextField.resignFirstResponder()
//        return true
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Selected For Group"
//        } else {
//            return "Not selected For Group"
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        
//        if section == 0 {
//            if filteredDataSource.count > 0 {
//                return filteredDataSource.count
//            } else {
//                return selectedUserIDs.count
//                // return selected users that were searched
//            }
//        } else if section == 1 {
//            if filteredDataSource.count > 0 {
//                return filteredDataSource.count
//            } else {
//                return usersDataSource.count // return non-selected users that were searched
//            }
//        } else {
//            return usersDataSource.count
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as? CreateAGroupTableViewCell
//        if indexPath.section == 0 {
//            let user = selectedUserIDs[indexPath.row]
//            cell?.delegate = self
//            cell?.userSelected()
//            cell?.selectedUserBooleon = true
//            return cell!
//        } else if indexPath.section == 1 {
//            let user = usersDataSource[indexPath.row]
//            cell?.delegate = self
//            cell?.userUnselected()
//            cell?.selectedUserBooleon = false
//            return cell!
//        }
//        return cell!
//        
//    }
//    // self.tableview.rowHeight = UITableView UITableViewAutomaticDimension
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            
//            if indexPath.section == 0 {
//                
//            }
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
//            
//            
//            
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        }
//        
//    }
//    
//    
//    
//    
//    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
//    
//    
//    func createGroup() {
//        
//        if let groupName = groupNameTextField.text {
//            guard let myIdentifier = UserController.sharedController.currentUser.identifier else {return}
//            selectedUserIDs.append(myIdentifier)
//            GroupController.createGroup(groupName, users: selectedUserIDs, completion: { (success, group) in
//                if (success != nil) {
//                    GroupController.passGroupIDsToUsers(self.selectedUserIDs, group:group, key: success!)
//                }
//                
//            })
//        }
//        
//    }
//    func showAlert(title: String, message: String) {
//        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
//        alert.addAction(action)
//        presentViewController(alert, animated: true, completion: nil)
//    }
//    
//}
//
//extension BuildAGroupViewController: CreateAGroupTableViewCellDelegate {
//    
//    func selectButtonTapped(sender: CreateAGroupTableViewCell) {
//        
//        let indexPath = tableView.indexPathForCell(sender)
//        
//        if indexPath?.section == 0 {
//            
//        }
//    }
//}
