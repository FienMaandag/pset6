//
//  NewPlantViewController.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 20-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class NewPlantViewController: UIViewController {


    @IBOutlet weak var plantNameLabel: UILabel!
    var plantName: String = ""
    var plants: [PlantTypes] = []
    var user: CurrentUser!
    let ref = Database.database().reference(withPath: "plant-types")
    let usersRef = Database.database().reference(withPath: "online")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plantName.capitalized
    }
    
    // Add plant to database
    @IBAction func addPlantButtonClicked(_ sender: AnyObject) {
        let user = Auth.auth().currentUser
        let text = plantName
        
        let plantTypes = PlantTypes(name: text,
                                    addedByUser: (user?.email!)!)

        let plantTypesRef = self.ref.child(text.lowercased())
        
        plantTypesRef.setValue(plantTypes.toAnyObject())

        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
