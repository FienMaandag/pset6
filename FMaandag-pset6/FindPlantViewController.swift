//
//  FindPlantViewController.swift
//  FMaandag-pset6
//
//  Shows the plant within de database in which the user can search
//
//  With help from the following tutorials
//  https://github.com/awseeley/Search-Tutorial/blob/master/TableViewTutorial/ViewController.swift
//  https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit

class FindPlantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!

    var allPlants = [String]()
    var filterdAllPlants = [String]()
    var shouldShowSearchResults = false
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterdAllPlants = allPlants
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterdAllPlants.count
    }
    
    // Fill cells of tableview with plants
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "foundPlantCell", for: indexPath as IndexPath) as! FoundPlantTableViewCell
        
            cell.foundPlantLabel.text = filterdAllPlants[indexPath.row].capitalized
        return cell
    }


    // Update search results
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filterdAllPlants = allPlants
        } else {
            // Filter the results
            filterdAllPlants = allPlants.filter { $0.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? NewPlantViewController{
            if let path = tableView.indexPathForSelectedRow{
                addVC.plantName = self.filterdAllPlants[path.row]
            }
            
        }
    }
    
}
