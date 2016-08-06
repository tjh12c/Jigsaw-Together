//
//  AuthorizationManager.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 8/1/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import Foundation
import Firebase


/**
 Provides interface for functions pertaining to authorization to Firebase account and server
 */
class AuthorizationManager {
    var error : NSError?
    
    
    init() {
    }
    
    
    
    
    /**
     Method used to create a user.
     - Parameters:
        - withEmail: The email to use
        - withPassword : The password to use
        - withUsername: The username to use
 
     - Throws:
        - InvalidEmailError : The email is not correctly structured
        - UsernameTakenError: The username is already taken
        - DatabaseConnectionError: Problem connecting to database
        - UnknownError: Other error
     */
    func createUser(withEmail email: String, withPassword password : String, withUsername username : String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            if let error = error {
                self.error = error
                return
            }
            else {
                
            }
        }
    }
    
    
    
    
    
    
    
    
}