//
//  SignUpViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/24/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signupButtonTapped(sender: AnyObject) {
        
        userController.createUser(emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!) { (success, user) in
            if success {
                self.performSegueWithIdentifier("fromSignupToWelcome", sender: nil)
            } else {
                print("Unable to create user. Please try again.")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
