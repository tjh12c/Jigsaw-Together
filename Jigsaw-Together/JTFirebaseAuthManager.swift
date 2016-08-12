//
//  JTFirebaseManager.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 7/29/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import Foundation
import Firebase

///Provides interface for functions pertaining to authorization to Firebase account and server
class JTFirebaseAuthManager {
    
    var createUserError : NSError?
    var signInError : NSError?
    
    ///Listener for the authorization state. Used to unregister the listener in deinit
    private var authListener : FIRAuthStateDidChangeListenerHandle!
    
    ///Reference to the Firebase realtime database
    private var ref : FIRDatabaseReference!
    ///The currently signed in user
    private var currentUser : FIRUser!
    
    
    ///Initialization. Set up a listener for auth state.
    init() {
        self.authListener = FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                print("AuthorizationManager init: username is \(user.displayName)")
                self.currentUser = user
            } else {
                print("AuthorizationManager init: no user authenticated")
                
            }
        }
        
        ///Set up reference to database
        self.ref = FIRDatabase.database().reference()
        
        
        
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
                self.saveUserToDatabase(user!, username: username)
            }
        }
    }
    
    
    /**
     Signs out the currently signed in user in Firebase, if there is one
     */
    func signOut() {
        try! FIRAuth.auth()!.signOut()
    }
    
    
    /**
     Signs in a user using Firebase Auth
     - Parameters:
     - withEmail: Email address of user
     - withPassword: Password for user
     */
    func signIn(withEmail email: String, withPassword password : String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if let error = error {
                self.signInError = error
            }
        }
    }
    
    //Private Class Methods
    
    private func saveUserToDatabase(user : FIRUser, username : String) {
        self.ref.child("data/users").child(username).child("uid").setValue(user.uid)
    }
}