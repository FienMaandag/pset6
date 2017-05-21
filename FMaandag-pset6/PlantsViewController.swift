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

    @IBOutlet weak var tableView: UITableView!
    
    var plants: [PlantTypes] = []
    var user: CurrentUser!
    let ref = Database.database().reference(withPath: "plant-types")
    let usersRef = Database.database().reference(withPath: "online")

    
    var foundPlants = [String]()
    var url = "http://www.growstuff.org/crops.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParser()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = CurrentUser(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        ref.observe(.value, with: { snapshot in
            var newPlants: [PlantTypes] = []
            print("1")
            for item in snapshot.children {
                print("2")
                let plantTypes = PlantTypes(snapshot: item as! DataSnapshot)
                print("3")
                newPlants.append(plantTypes)
                print("4")
            }
            
            self.plants = newPlants
            print("5")
            self.tableView.reloadData()
            print("6")
        })
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let findVC = segue.destination as? FindPlantViewController{
            findVC.foundPlants = foundPlants
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! PlantTableViewCell
        print("7")
        let plantSort = plants[indexPath.row].name
        print(plantSort)
        cell.myPlantNameLabel.text = plantSort
        print("9")
        
        return cell
    }
    
    // TODO delete function
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func jsonParser() {
        let urlPath = url
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject

                let plants = json as? [AnyObject]
                
                for plant in plants!
                {
                    let plantname = plant["name"] as! String
                    
                    DispatchQueue.main.async()
                        {
                            self.foundPlants.append(plantname)
                    }
                }
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }.resume()
    }
}
