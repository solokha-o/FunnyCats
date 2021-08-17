//
//  CatGalleryCollectionViewCell.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 05.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import Combine

class CatGalleryCollectionViewCell: UICollectionViewCell {
    
    //add instance of GuessCatRequest
    let guessCatRequest = GuessCatRequest()
    //create instance guess cat model
    var guessCat = [GuessCatDataBaseModel]()
    // photo instance
    var photo : UIImageView?
    
    var subscriptions = Set<AnyCancellable>() //instance is used for to load data
    
    @IBOutlet weak var catImageView: UIImageView!
    // get photo cat from request and set to catImageView
    func set(catBreed: CatBreedsDataBaseModel) {
        guessCatRequest.loadCat(breedId: catBreed.id) { [weak self] guessCat in
            self?.guessCat = guessCat
            if !guessCat[0].url.isEmpty {
                DispatchQueue.main.async {
                    guard let url = URL(string: guessCat[0].url) else { return }
                   
                    //issue was configured that image was loaded by using Combine
                    ImageLoader.shared.publisher(for: url).sink { (image) in
                        self?.catImageView.image = image
                        
                    }.store(in: &self!.subscriptions)
                }
            }
        }
    }
}

