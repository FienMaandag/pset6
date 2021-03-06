//
//  User.swift
//  FMaandag-pset6
//
//  With help from the tutorial raywenderlich.com/139322/firebase-tutorial-getting-started-2
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}

