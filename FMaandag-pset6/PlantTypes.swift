//
//  PlantTypes.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//  https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2

import Foundation
import Firebase

struct PlantTypes {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    let nickname: String
    
    init(name: String, addedByUser: String, key: String = "", nickname: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.ref = nil
        self.nickname = nickname
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        ref = snapshot.ref
        nickname = snapshotValue["nickname"] as? String ?? ""
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "nickname": nickname,
        ]
    }
    
}
