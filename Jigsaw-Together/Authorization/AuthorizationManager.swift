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
    var createUserError : NSError?
    var signInError : NSError?
    
    ///Listener for the authorization state. Used to unregister the listener in deinit
    var authListener : FIRAuthStateDidChangeListenerHandle!
    
    ///Initialization. Set up a listener for auth state.
    init() {
        self.authListener = FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("AuthorizationManager init: username is \(user.displayName)")
            } else {
                print("AuthorizationManager init: no user authenticated")
            }
        }
    }
    
    ///Deinitialization. Remove the listener to prevent memory leaks.
    deinit {
        FIRAuth.auth()?.removeAuthStateDidChangeListener(self.authListener)
    }
    
    
    /**
     Method used to create a user.
     - Parameters:
        - withEmail: The email to use
        - withPassword : The password to use
        - withUsername: The username to use
 
     - Note: Any errors will be placed in the object's "createUserError" variable. An observer is recommended
     */
    func createUser(withEmail email: String, withPassword password : String, withUsername username : String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            if let error = error {
                print("AuthorizationManager error: createUser has error \(error.localizedDescription)")
                self.createUserError = error
            }
            else {
                print("No Error")
            }
        }
    }
    
    func signOut() {
        try! FIRAuth.auth()!.signOut()
    }
    
    func signIn(withEmail email: String, withPassword password : String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let error = error {
                self.signInError = error
            }
        }
    }
    
    
    
}