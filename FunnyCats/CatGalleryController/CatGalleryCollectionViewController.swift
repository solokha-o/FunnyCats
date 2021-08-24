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
        cell.layer.cornerRadius = 20
        // setup activityIndicator in cell
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.layer.cornerRadius = 10.0
        activityIndicator.style = .medium
        activityIndicator.backgroundColor = .systemTeal
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: cell.contentView.frame.width / 2, y: cell.contentView.frame.height / 2)
        cell.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    // configure didSelectItemAt to show DetailCatPhotoViewController
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let catGalleryCVC = collectionView.cellForItem(at: indexPath) as? CatGalleryCollectionViewCell, let detailCatPhotoVC = storyboard?.instantiateViewController(identifier: "DetailCatPhotoViewController") as? DetailCatPhotoViewController else { return }
        _ = detailCatPhotoVC.view
        detailCatPhotoVC.nameCatBreedLable.text = catBreeds[indexPath.row].name
        detailCatPhotoVC.photoImageView.image = catGalleryCVC.catImageView.image
        showDetailViewController(detailCatPhotoVC, sender: nil)
    }
    //cancel task hidden cell
//    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let catGalleryCVC = collectionView.cellForItem(at: indexPath) as? CatGalleryCollectionViewCell else { return }
//    }
    
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Cats Photo Gallety"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
    // load array catBreeds
    func loadCatBreeds() {
        let decoder = JSONDecoder()
        if let decoded = UserDefaults.standard.object(forKey: "catBreeds") as? Data {
            if let catBreeds = try? decoder.decode([CatBreedsDataBaseModel].self, from: decoded) {
                self.catBreeds = catBreeds
            }
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
