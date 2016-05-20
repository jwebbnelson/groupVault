//
//  SignUpViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/24/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        downSwipeGesture()
        upSwipeGesture()
        tapGestureToDismissKeyBoard()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        if let newUsersUsername = usernameTextField.text,
            email = emailTextField.text,
            password = passwordTextField.text where email.characters.contains("@") && password.characters.count >= 6 {
            let usernameDictionaries = FirebaseController.base.childByAppendingPath("users")
            usernameDictionaries.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                var usernames: [String] = []
                if let users = snapshot.value as? [String : AnyObject] {
                    for userKey in users.keys {
                        if let user = users[userKey] as? [String : AnyObject] {
                            if let username = user["username"] as? String {
                                usernames.append(username)
                                print(username)
                                print(usernames)
                            }
                            print(user)
                        }
                        print(userKey)
                    }
                }
                
                if usernames.contains(newUsersUsername) {
                    self.showSignupAlert("Sorry!", message: "That username is being used. Please try another.")
                } else {
                    UserController.createUser(email, password: password, username: newUsersUsername, completion: { (success, user) in
                        if success {
                            self.performSegueWithIdentifier("fromSignupToWelcome", sender: nil)
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
