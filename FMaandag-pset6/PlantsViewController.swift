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
        
        let username = Auth.auth().currentUser?.email
        let searchRef = Database.database().reference().child("plant-types").queryOrdered(byChild: "addedByUser").queryEqual(toValue: username)

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
        let plantSort = plants[indexPath.row]
        cell.myPlantNameLabel.text = plantSort.name.capitalized
        cell.nicknameLabel.text = plantSort.nickname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Add Nickname",
                                      message: "name your plant!",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let nicknameField = alert.textFields![0]
            let cell = tableView.cellForRow(at: indexPath) as! PlantTableViewCell
            let text = nicknameField.text
            
            cell.nicknameLabel.isHidden = false
            cell.nicknameLabel.text = text
            
            let plant = self.plants[indexPath.row]
            self.ref.updateChildValues([
                "\(plant.key)/nickname" : text
            ])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textNickname in
            textNickname.placeholder = "Nickname"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedPlant = plants[indexPath.row]
            selectedPlant.ref?.removeValue()
        }
    }
    
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
