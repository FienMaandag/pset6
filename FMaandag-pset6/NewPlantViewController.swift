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

    var plantName: String = ""
    @IBOutlet weak var plantNameLabel: UILabel!
    
    var plants: [PlantTypes] = []
    var user: User!
    let ref = Database.database().reference(withPath: "plant-types")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantNameLabel.text = plantName
        
        // TODO add extra information
    }
    
    @IBAction func addPlantButtonClicked(_ sender: UIButton) {
        // TODO add plant to firebase for current user
        let name = plantName
        
        let email: String = UserDefaults.standard.string(forKey: "current")
        
        let plantType = (name: name, addedByUser: email)
        
        let plantTypeRef = self.ref.child(plantName.lowercased())
        
        plantTypeRef.setValue(plantType.toAnyObject())
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
