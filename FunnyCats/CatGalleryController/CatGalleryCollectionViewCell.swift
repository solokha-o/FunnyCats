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
    
    var subscriptions = Set<AnyCancellable>() //instance is used for to load data
    
    @IBOutlet weak var catImageView: UIImageView!
    // get photo using Combine
    func set(catBreed: CatBreedsDataBaseModel) {
        
        if let link = catBreed.image?.url, let url = URL(string: link) {
            
            //issue was configured that image was loaded by using Combine
            ImageLoader.shared.publisher(for: url).sink { [weak self] (image) in
                
                guard let self = self else { return }
                
                self.catImageView.image = image
                
            }.store(in: &self.subscriptions)
        }
    }
}

