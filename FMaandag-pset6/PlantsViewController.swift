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

//    var plants: [PlantTypes] = []
//    var user: User!
    
    var plants = [(name: String, addedBy: String)]()
    
    let ref = Database.database().reference(withPath: "plant-types")
    
    var foundPlants = [String]()
    var url = "http://www.growstuff.org/crops.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParser()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            let currentUser = user.email!
            UserDefaults.standard.set(currentUser, forKey: "current")
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
        let plantSort = plants[indexPath.row].name
        
        cell.myPlantNameLabel.text = plantSort
        
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
