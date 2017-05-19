//
//  FindPlantViewController.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit

class FindPlantViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var foundPlants = [(id: Int64, name: String)]()
    var url = "http://www.growstuff.org/crops/1.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonParser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foundPlantCell", for: indexPath) as! FoundPlantTableViewCell
        let plant = foundPlants[indexPath.row]
        
        return cell
    }
}
