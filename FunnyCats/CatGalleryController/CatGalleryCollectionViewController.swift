//
//  CatGalleryCollectionViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 05.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit


class CatGalleryCollectionViewController: UICollectionViewController {
    
    // create array of cat breeds
    var catBreeds = [CatBreedsDataBaseModel]()
    // add instance of GetCatBreedsRequest
    let getCatBreeds = GetCatBreedsRequest()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // call setup and configuration function
        configNavigationBar()
        loadCatBreeds()
        setupFlowLayout()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    // configure number of sections and items
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catBreeds.count
    }
    //configure cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? CatGalleryCollectionViewCell else { return UICollectionViewCell() }
        cell.set(catBreed: catBreeds[indexPath.row])
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Cats Photo Gallety"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
    // load array catBreeds
    func loadCatBreeds() {
        self.getCatBreeds.loadCatBreeds { [weak self] catBreeds in
            self?.catBreeds = catBreeds
            self?.collectionView.reloadData()
        }
    }
    //setup flow layout to collection view
    func setupFlowLayout() {
        let itemsInLine : CGFloat = 2
        let selectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let retreatgWidth = selectionInserts.left * (itemsInLine + 1)
        print(retreatgWidth)
        let availableWidth = collectionView.frame.width - retreatgWidth
        print(availableWidth)
        let widthItem = availableWidth / itemsInLine
        print(widthItem)
        layout.itemSize = CGSize(width: widthItem, height: widthItem)
        layout.sectionInset = selectionInserts
        layout.minimumLineSpacing = selectionInserts.left
        layout.minimumInteritemSpacing = selectionInserts.left
    }
}
