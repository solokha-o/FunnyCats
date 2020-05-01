//
//  CatBreedsTableViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class CatBreedsTableViewController: UITableViewController {
    
    // create array of cat breeds
    var catBreeds = [CatBreedsDataBaseModel]()
    // add intance of GetCatBreedsRequest
    let getCatBreeds = GetCatBreedsRequest()
    // create property for search bar and filtered results
    let search = UISearchController(searchResultsController: nil)
    var filteredCatBreeds = [CatBreedsDataBaseModel]()
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        getCatBreeds.getCatBreeds { [weak self] catBreeds in
            self?.catBreeds = catBreeds
            self?.tableView.reloadData()
        }
        // configure searchBar
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search cat breeds 😻"
        definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of row return from array cat breeds or filtering results
        if isFiltering {
            return filteredCatBreeds.count
        }
        return catBreeds.count
    }
    // configure cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        switch isFiltering {
        case true:
            cell.textLabel?.text = filteredCatBreeds[indexPath.row].name
            cell.detailTextLabel?.text = "Country of Origin - " + filteredCatBreeds[indexPath.row].origin
        case false:
            cell.textLabel?.text = catBreeds[indexPath.row].name
            cell.detailTextLabel?.text = "Country of Origin - " + catBreeds[indexPath.row].origin
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    // configure didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlCatBreed = catBreeds[indexPath.row].wikipediaURL
        guard let detailCatBreedVC = storyboard?.instantiateViewController(identifier: "DetailCatBreedViewController") as? DetailCatBreedViewController else { return }
        //show in detail view controller cat breed from url wikipedia
        detailCatBreedVC.getUrl = urlCatBreed ?? "https://google.com"
        show(detailCatBreedVC, sender: nil)
    }
    // func for filter Content For Search Text
    func filterContentForSearchText(_ searchText: String) {
        filteredCatBreeds = catBreeds.filter { (catBreed: CatBreedsDataBaseModel) -> Bool in
            return (catBreed.name.lowercased().contains(searchText.lowercased())) || (catBreed.origin.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Cat breeds"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
}
// add extension UISearchResultsUpdating
extension CatBreedsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

