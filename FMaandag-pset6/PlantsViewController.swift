//
//  PlantsViewController.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class PlantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var plants: [PlantTypes] = []
    var user: User!
    let ref = Database.database().reference(withPath: "plant-types")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! PlantTableViewCell
        let plantSort = plants[indexPath.row]
        
        // cell.todoLabel.text = itemList[indexPath.row].todo
        // let value = itemList[indexPath.row].completed
        // cell.doneSwitch.setOn(value, animated: true)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // itemList.remove(at: indexPath.row)
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
