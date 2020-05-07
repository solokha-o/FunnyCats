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
    // create activity indicator
    var activityIndicator = UIActivityIndicatorView()
    //    // create refresh control to reload tableview
    //    var refrechControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        getCatBreeds.loadCatBreeds { [weak self] catBreeds in
            self?.catBreeds = catBreeds
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.tableView.backgroundView = nil
        }
        // configure searchBar
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search cat breeds 😻"
        definesPresentationContext = true
        tableView.tableFooterView = UIView()
        // call activity indicator
        configActivityIndicator()
        
        //        pullRefreshTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        var urlCatBreed : String
        var catBreed : String
        switch isFiltering {
        case true:
            urlCatBreed = filteredCatBreeds[indexPath.row].wikipediaURL ?? "https://google.com"
            catBreed = filteredCatBreeds[indexPath.row].name
        case false:
            urlCatBreed = catBreeds[indexPath.row].wikipediaURL ?? "https://google.com"
            catBreed = catBreeds[indexPath.row].name
        }
        guard let detailCatBreedVC = storyboard?.instantiateViewController(identifier: "DetailCatBreedViewController") as? DetailCatBreedViewController else { return }
        //show in detail view controller cat breed from url wikipedia
        detailCatBreedVC.getUrl = urlCatBreed
        detailCatBreedVC.navigationItemTitle = catBreed
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
    // configure activity Indicator
    func configActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = .systemTeal
        activityIndicator.hidesWhenStopped = true
    }
    //    // configure refresh control
    //    func pullRefreshTableView() {
    //        refrechControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    //        refrechControl.addTarget(self, action: #selector(self.refreshTableView), for: .touchDown)
    //    }
    //    @objc func refreshTableView() {
    //        getCatBreeds.loadCatBreeds { [weak self] catBreeds in
    //            self?.catBreeds = catBreeds
    //            self?.tableView.reloadData()
    //        }
    //    }
}
// add extension UISearchResultsUpdating
extension CatBreedsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

