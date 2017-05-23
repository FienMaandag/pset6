//
//  FindPlantViewController.swift
//  FMaandag-pset6
//
//  Created by Fien Maandag on 19-05-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//  https://github.com/awseeley/Search-Tutorial/blob/master/TableViewTutorial/ViewController.swift

import UIKit

class FindPlantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!

    var foundPlants = [String]()
    var filterdFoundPlants = [String]()
    var shouldShowSearchResults = false
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterdFoundPlants = foundPlants
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterdFoundPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "foundPlantCell", for: indexPath as IndexPath) as! FoundPlantTableViewCell
        
            cell.foundPlantLabel.text = filterdFoundPlants[indexPath.row]
        return cell
    }


    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filterdFoundPlants = foundPlants
        } else {
            // Filter the results
            filterdFoundPlants = foundPlants.filter { $0.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? NewPlantViewController{
            if let path = tableView.indexPathForSelectedRow{
                addVC.plantName = self.filterdFoundPlants[path.row]
            }
            
        }
    }
    
}
