//
//  PlantsViewController.swift
//  FMaandag-pset6
//
//  Loads the plants the current user has saved
//
//  With help from tutotial https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
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
    var allPlants = [String]()
    var url = "http://www.growstuff.org/crops.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonParser()
        
        // From tutorial, Login current user
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = CurrentUser(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        let username = Auth.auth().currentUser?.email
        let searchRef = Database.database().reference().child("plant-types").queryOrdered(byChild: "addedByUser").queryEqual(toValue: username)

        // View plants from current user
        searchRef.observe(.value, with: { snapshot in
            var newPlants: [PlantTypes] = []
            for item in snapshot.children {
                let plantTypes = PlantTypes(snapshot: item as! DataSnapshot)
    
                newPlants.append(plantTypes)
            }
            self.plants = newPlants
            self.tableView.reloadData()
        }) { (error) in
                print("Failed to get snapshot", error.localizedDescription)
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Logout current user
    @IBAction func logOutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let findVC = segue.destination as? FindPlantViewController{
            findVC.allPlants = allPlants
        }
    }
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    // Fill cells of tableview with plants
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! PlantTableViewCell
        let plantSort = plants[indexPath.row]
        cell.myPlantNameLabel.text = plantSort.name.capitalized
        cell.nicknameLabel.text = plantSort.nickname.capitalized
        
        return cell
    }
    
    // Give a nickname to selected plant
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Add Nickname",
                                      message: "name your plant!",
                                      preferredStyle: .alert)
        
        // Saves nickname for plant
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let nicknameField = alert.textFields![0]
            let text = nicknameField.text
            
            let plant = self.plants[indexPath.row]
            self.ref.updateChildValues([
                "\(plant.key)/nickname" : text
            ])
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textNickname in
            textNickname.placeholder = "Nickname"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Delete plant from tableview and firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedPlant = plants[indexPath.row]
            selectedPlant.ref?.removeValue()
        }
    }
    
    // Setting up error messages
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // Parse data from API
    func jsonParser() {
        let urlPath = url
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        
        // Get data
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                // Save plants
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                let plants = json as? [AnyObject]
                
                // Get name from plant
                for plant in plants! {
                    let plantname = plant["name"] as! String
                    
                    DispatchQueue.main.async() {
                            self.allPlants.append(plantname)
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
