
//  MessageBoardViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 5/20/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class MessageBoardViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var group: Group?
    var groupMessages: [Message] = []
    var groupImages: [Image] = []
    var currentGroup = ""
    var timer: Timer?
    var message: Message?
    let currentUser = UserController.sharedController.currentUser
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var cameraImage: UIButton!
    
    @IBOutlet weak var practiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(MessageBoardViewController.cameraImageTapped))
        cameraImage.userInteractionEnabled = true
        cameraImage.addGestureRecognizer(cameraTapGesture)
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
        let allImages = groupImages
        for image in allImages {
            if image.timer != nil {
                TimerController.sharedInstance.stopTimer(image.timer ?? Timer())
            }
        }
    }
    @IBAction func showMessageButtonTapped(sender: AnyObject) {
        
        
    }
    
    
    
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        //        self.scrollToLastRow(true)
        if messageTextField.text == "" {
            print("text must be entered in order to send a message")
        } else {
            createMessage()
            messageTextField.text = ""
        }
        
    }
    
    func createMessage() {
        if let message = messageTextField.text, currentUser = self.currentUser, currentUserID = self.currentUser.identifier, currentUserImage = self.currentUser.imageString {
            if let group = group, let identifier = group.identifier {
                MessageController.createMessage(currentUserID, senderName: currentUser.username, senderImageString: currentUserImage, groupID: identifier, text: message, timer: Timer(), viewedBy: [], completion: { (success, message) in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupMessages.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let message = groupMessages[indexPath.row]
//        let image = groupImages[indexPath.row]
        
        
        if message.sender == self.currentUser.identifier {
            
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func updateWith(group: Group) {
        self.groupNameLabel.text = group.groupName
        self.group = group
        
//        ImageController.fetchImagesForGroup(group) { (images) in
//            if images.count > self.groupMessages.count {
//                self.groupImages = images.sort({ $0.identifier < $1.identifier })
//                self.tableView.reloadData()
//            } else {
//                self.groupImages = images.sort({ $0.identifier < $1.identifier })
//
//            }
//        }
        MessageController.fetchMessagesForGroup(group) { (messages) in
            if messages.count > self.groupMessages.count {
                self.groupMessages = messages.sort({ $0.identifier < $1.identifier })
                self.tableView.reloadData()
            } else {
                self.groupMessages = messages.sort({ $0.identifier < $1.identifier })
            }
        }
    }
    
    func cameraImageTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let cameraAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            cameraAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                cameraAlert.addAction(UIAlertAction(title: "Take Photo or Video", style: .Default, handler: { (_) in
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .Camera
                    imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }))
            }
        }
        
        cameraAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(cameraAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        guard let image = pickedImage,
        currentUser = self.currentUser,
        currentUserID = self.currentUser.identifier,
            currentUserImage = self.currentUser.imageString else { return }
        if let group = group, let identifier = group.identifier {
            ImageController.uploadGroupMessageImage(currentUserID, senderName: currentUser.username, groupID: identifier, image: image, timer: Timer(), viewedBy: [], completion: { (success, image) in
                if success == true {
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.practiceImageView.image = pickedImage
                        self.tableView.reloadData()
                    })
                } else {
                    print("image not saved")
                }
            })
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("user cancelled image")
        dismissViewControllerAnimated(true) {
            // anything you want to happen when the user selects cancel
        }
    }
    
    func imageWasSavedSuccessfully(image: UIImage, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>) {
        print("Image saved")
        if let error = error {
            print("An error occured while waving the image. \(error.localizedDescription)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.practiceImageView.image = image
            })
        }
    }
    
    
    
    func scrollToBottom(bool: Bool){
        if self.groupMessages.count > 0 {
            let lastRowNumer = self.groupMessages.count - 1
            let indexPath = NSIndexPath(forRow: lastRowNumer, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: bool)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
}


extension MessageBoardViewController: SenderTableViewCellDelegate, RecieverTableViewCellDelegate {
    
    func senderMessageSent(sender: SenderCell) {
        
    }
    
    func receiverLockImagebuttonTapped(sender: ReceiverCell) {
        
        guard let message = sender.message,
            currentUserID = self.currentUser.identifier,
            viewedByArray = message.viewedBy else { return }
        if viewedByArray.contains(currentUserID) {
            sender.goBackToLockImageView()
        } else {
            TimerController.sharedInstance.startTimer(message.timer ?? Timer())
            sender.messageViewForReceiver(message)
        }
    }
}


