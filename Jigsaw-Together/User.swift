//
//  User.swift
//  Jigsaw-Together
//
//  Created by Tyler Hunnefeld on 8/11/16.
//  Copyright © 2016 ThinkBig Applications. All rights reserved.
//

import Foundation

/**
 User class for Firebase
 Initialized with email, username, and password
 - Note: Currently these are not required!
 */
class User : NSObject {
    var email : String!
    var username : String!
    var password : String!
    
    init(withEmail email : String, withUsername username : String, withPassword password : String) {
        self.email = email
        self.username = username
        self.password = password
    }
}