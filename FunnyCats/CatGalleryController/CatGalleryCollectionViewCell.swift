//
//  CatGalleryCollectionViewCell.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 05.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class CatGalleryCollectionViewCell: UICollectionViewCell {
    
    //add instance of GuessCatRequest
    let guessCatRequest = GuessCatRequest()
    //create instance guess cat model
    var guessCat = [GuessCatDataBaseModel]()
    
    @IBOutlet weak var catImageView: UIImageView!
    
    // get photo cat from request and set to catImageView
    func set(catBreed: CatBreedsDataBaseModel) {
        guessCatRequest.loadCat(breedId: catBreed.id) { [weak self] guessCat in
            self?.guessCat = guessCat
            if !guessCat[0].url.isEmpty {
                DispatchQueue.main.async {
                    guard let url = URL(string: guessCat[0].url) else { return }
                    self?.catImageView.load(url: url)
                }
            }
            
        }
    }
}

