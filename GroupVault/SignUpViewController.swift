//
//  SignUpViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/24/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var blurryView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurryView.hidden = true
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        profileImage.alpha = 0
        downSwipeGesture()
        upSwipeGesture()
        tapGestureToDismissKeyBoard()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.okButtonTapped))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        if let newUsersUsername = usernameTextField.text,
            email = emailTextField.text,
            password = passwordTextField.text where email.characters.contains("@") && password.characters.count >= 6 {
            self.startFetchingDataIndicator()
            let usernameDictionaries = FirebaseController.base.childByAppendingPath("users")
            usernameDictionaries.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                var usernames: [String] = []
                if let users = snapshot.value as? [String : AnyObject] {
                    for userKey in users.keys {
                        if let user = users[userKey] as? [String : AnyObject] {
                            if let username = user["username"] as? String {
                                usernames.append(username)
                            }
                        }
                    }
                }
                
                if usernames.contains(newUsersUsername) {
                    self.stopFetchingDataIndicator()
                    self.showSignupAlert("Sorry!", message: "That username is being used. Please try another.")
                } else {
                    self.stopFetchingDataIndicator()
                    UserController.createUser(email, password: password, username: newUsersUsername, completion: { (success, user) in
                        if success {
                            self.almostDoneAlert("Account succefully created!", message: "Now set a profile picture to continue!")
                        } else {
                            self.showSignupAlert("Unable to create account.", message: "Try a different e-mail or find a location with better service")
                        }
                    })
                }
                
            })
            
        } else {
            self.showSignupAlert("Invalid information", message: "Provide:\n-email\n-password (6 or more characters) \n-username")
        }
    }
    
    func okButtonTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.allowsEditing = true
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                alert.addAction(UIAlertAction(title: "Take Photo or Video", style: .Default, handler: { (_) in
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .Camera
                    imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }))
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = pickedImage {
            ImageController.uploadProfileImage(UserController.sharedController.currentUser, image: image, completion: { (identifier) in
                UIView.animateWithDuration(4.0, animations: {
                    self.profileImage.alpha = 1.0
                    self.profileImage.image = image
                    }, completion: { (_) in
                        sleep(1)
                        self.performSegueWithIdentifier("fromSignupToWelcome", sender: nil)
                })
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
                
            })
        }
    }
    
    func downSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.swiped)
        )
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
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            usernameTextField.resignFirstResponder()
        case UISwipeGestureRecognizerDirection.Up:
            emailTextField.becomeFirstResponder()
            passwordTextField.becomeFirstResponder()
            usernameTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        return true
    }
    
    func tapGestureToDismissKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    func showSignupAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func almostDoneAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.okButtonTapped()
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func startFetchingDataIndicator() {
        self.blurryView.hidden = false
        self.loadingIndicator.startAnimating()
        
        
    }
    
    func stopFetchingDataIndicator() {
        self.blurryView.hidden = true
        self.loadingIndicator.stopAnimating()
    }

    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
