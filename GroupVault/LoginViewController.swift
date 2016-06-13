//
//  LoginViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var user: User?
    
    var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var fetchingDataIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var createAccountOutlet: UIButton!
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    @IBOutlet weak var blurryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurryView.hidden = true
        fetchingDataIndicator.hidesWhenStopped = true
        fetchingDataIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        downSwipeGesture()
        upSwipeGesture()
        tapGestureToDismissKeyBoard()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        self.hideKeyboard()
        
        //        self.disableUserInteraction(true)
        
        if let email = emailTextField.text,
            password = passwordTextField.text {
            
            self.startFetchingDataIndicator()
            UserController.authenticateUser(email, password: password, completion: { (success, user) in
                
                if success {
                    self.stopFetchingDataIndicator()
                    self.performSegueWithIdentifier("toWelcomView", sender: nil)
                    
                } else {
                    self.stopFetchingDataIndicator()
                    self.showLoginAlert("Invalid information", message: "Provide:\n-jemail\n-password (6 or more characters)")
                }
            })
        }
        
    }
    
    
    @IBAction func CreateAccount(sender: AnyObject) {
        emailTextField.text = ""
        passwordTextField.text = ""
        print("AAAAAA")
        
    }
    
    
    func downSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.swiped)
        )
        swipeDown.direction = .Down
        self.view.addGestureRecognizer(swipeDown)
    }
    func upSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.swiped)
        )
        swipeUp.direction = .Up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    
    func swiped(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Down:
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        case UISwipeGestureRecognizerDirection.Up:
            emailTextField.becomeFirstResponder()
            passwordTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if passwordTextField.text != "" {
            self.createAccountOutlet.hidden = true
            self.buttonStackView.frame = CGRect(x: buttonStackView.frame.origin.x, y: buttonStackView.frame.origin.y, width: 50, height: 20)
        }
    }
    
    func tapGestureToDismissKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showLoginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func startFetchingDataIndicator() {
        self.blurryView.hidden = false
        fetchingDataIndicator.startAnimating()
        
        
    }
    
    func stopFetchingDataIndicator() {
        self.blurryView.hidden = true
        fetchingDataIndicator.stopAnimating()
    }
    
    //        func addBackGroundBlurEffect() {
    //            view.backgroundColor = UIColor.clearColor()
    //
    //            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    //            visualEffectView = UIVisualEffectView(effect: blurEffect)
    //
    //            visualEffectView.frame = self.blurryView.bounds
    //            visualEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    //            self.view.addSubview(visualEffectView)
    //        }
    //
    //        func removeBackgroundBlurEffect() {
    //            visualEffectView.removeFromSuperview()
    //            self.view.backgroundColor = UIColor.whiteColor()
    //
    //        }
}







/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */




