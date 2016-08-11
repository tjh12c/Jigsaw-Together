//
//  AuthorizationController.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 8/11/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import UIKit

/**
 Using primarily for testing AuthorizationManager class
*/
class AuthorizationController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressButton(sender: UIButton) {
        if !self.emailField.hasText() {
            return
        }
        if !self.passwordField.hasText() {
            return
        }
        if !self.usernameField.hasText() {
            return
        }
        
        let email = self.emailField.text!
        let password = self.passwordField.text!
        let username = self.usernameField.text!
        
        let auth = AuthorizationManager()
        
        auth.createUser(withEmail: email, withPassword: password, withUsername: username)
        
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
