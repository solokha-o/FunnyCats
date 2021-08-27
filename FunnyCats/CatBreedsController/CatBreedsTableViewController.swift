//
//  CatBreedsTableViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import Combine

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
    
    private var subscriptions = Set<AnyCancellable>() //instance is used for to load data
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        //        getCatBreeds.loadCatBreeds { [weak self] catBreeds in
        //            self?.catBreeds = catBreeds
        //            self?.tableView.reloadData()
        //            self?.activityIndicator.stopAnimating()
        //            self?.tableView.backgroundView = nil
        //        }
        //issue was configured that data was loaded by using Combine

        loadData()
        refreshTableView()
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
      
        var selectedCatBreed : CatBreedsDataBaseModel
        
        switch isFiltering {
            case true:
                selectedCatBreed = filteredCatBreeds[indexPath.row]
            case false:
                selectedCatBreed = catBreeds[indexPath.row]
        }
        
        guard let detailCatBreedVC = storyboard?.instantiateViewController(identifier: "DetailCatBreedViewController") as? DetailCatBreedViewController else { return }
        //show in detail view controller cat breed from url wikipedia
        detailCatBreedVC.catBreed = selectedCatBreed
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
    
    //load data
    @objc private func loadData() {
        DataLoader.loadData(link: Constant.linkLoadCatBreeds).sink(receiveCompletion: { completion in
            
            switch completion {
                case .finished:
                    print("finished") // not printing
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }) { [weak self] (catBreeds: [CatBreedsDataBaseModel]) in
            
            guard let self = self else { return }
            
            self.catBreeds = catBreeds
            
            self.tableView.reloadData()
            self.tableView.backgroundView = nil
            
            self.activityIndicator.stopAnimating()
            
            self.refreshControl?.endRefreshing()
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(catBreeds) {
                UserDefaults.standard.set(encoded, forKey: "catBreeds")
            }
            
        }.store(in: &subscriptions)
    }
    //refresh tableView
    private func refreshTableView() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
}
// add extension UISearchResultsUpdating
extension CatBreedsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = search.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

