//
//  LoginSignupViewController.swift
//  GroupVault
//
//  Created by Jonathan Rogers on 3/22/16.
//  Copyright © 2016 Jonathan Rogers. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    
    var user: User?
    
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func loginSignUpButtonTapped(sender: AnyObject) {
        
        if let email = emailTextField.text where email != "",
            let password = passwordTextField.text where password != "" {
            
            UserController.authenticateUser(email, password: password, completion: { (success, user) in
                if success {
                    
                    
                    
                    
                    self.performSegueWithIdentifier("toWelcomView", sender: nil)
                } else {
                    print("Unable to authenticate user. Please Try again Later")
                }
            })
        }
    }
    
    
    @IBAction func CreateAccount(sender: AnyObject) {
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
