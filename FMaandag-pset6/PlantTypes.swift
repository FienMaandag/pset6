//
//  PlantTypes.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct PlantTypes {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    //     var completed: Bool
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
//        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
//        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
//            "completed": completed
        ]
    }
    
}
