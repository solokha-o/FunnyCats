//
//  DetailCatPhotoViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 07.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class DetailCatPhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var shareButtonOutlet: UIButton!
    @IBOutlet weak var nameCatBreedLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call configuration and setup function
        setupController()
    }
    // configure button share
    @IBAction func shareButtonAction(_ sender: UIButton) {
        // setup UIActivityViewController for share photo
        let shareItem = [photoImageView.image!]
        let shareController = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                print("Photo save in librery of phone!")
            }
        }
        shareController.popoverPresentationController?.sourceView = sender
        present(shareController, animated: true)
    }
    // configure object in controller
    func setupController() {
        view.backgroundColor = .black
        shareButtonOutlet.tintColor = .white
        shareButtonOutlet.setTitleColor(.white, for: .normal)
        shareButtonOutlet.setTitle(" Tap to share", for: .normal)
        let battonImage = UIImage(systemName: "square.and.arrow.up")
        shareButtonOutlet.setImage(battonImage, for: .normal)
        nameCatBreedLable.backgroundColor = .black
        nameCatBreedLable.textColor = .white
    }
}
