//
//  GuessCatViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 01.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class GuessCatViewController: UIViewController {
    
    @IBOutlet weak var guessCatLable: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var checkAnswerLable: UILabel!
    @IBOutlet weak var answerLeftButtonOutlet: UIButton!
    @IBOutlet weak var answerRightButtonOutlet: UIButton!
    @IBOutlet weak var nextQuestionButtonOutlet: UIButton!
    
    // create array of cat breeds
    var catBreeds = [CatBreedsDataBaseModel]()
    // add instance of GetCatBreedsRequest
    let getCatBreeds = GetCatBreedsRequest()
    //add instance of GuessCatRequest
    let guessCatRequest = GuessCatRequest()
    //create instance guess cat model
    var guessCat = [GuessCatDataBaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call setup and configure function
        configNavigationBar()
        setupController()
        DispatchQueue.main.async {
            //load cat breeds
            self.getCatBreeds.loadCatBreeds { [weak self] catBreeds in
                self?.catBreeds = catBreeds
                self?.loadImageCatBreed(catBreeds: catBreeds)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func answerLeftButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func answerRightButtonAction(_ sender: UIButton) {
    }
    // configure next question button by use random breed
    @IBAction func nextQuestionButtonAction(_ sender: UIButton) {
        UIImageView.animate(withDuration: 1.0) {
            self.loadImageCatBreed(catBreeds: self.catBreeds)
        }
    }
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Guess cat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
    // random cat breed id
    func randomBreed(catBreeds: [CatBreedsDataBaseModel]) -> String {
        let randomBreed = Int.random(in: catBreeds.indices)
        let breedId = catBreeds[randomBreed].id
        return breedId
    }
    // load image cat breed
    func loadImageCatBreed(catBreeds: [CatBreedsDataBaseModel]) {
        guessCatRequest.loadCat(breedId: randomBreed(catBreeds: catBreeds)) { [weak self] guessCat in
            DispatchQueue.main.async {
                self?.guessCat = guessCat
                guard let url = URL(string: guessCat[0].url) else { return }
                self?.catImageView.load(url: url)
            }
        }
    }
    // configure controller
    func setupController() {
        guessCatLable.text = "Guess the breed by the photo"
        catImageView.contentMode = .scaleAspectFill
        catImageView.layer.masksToBounds = true
        catImageView.layer.cornerRadius = 20.0
        answerLeftButtonOutlet.backgroundColor = .systemTeal
        answerLeftButtonOutlet.tintColor = .black
        answerLeftButtonOutlet.layer.cornerRadius = 10.0
        answerRightButtonOutlet.backgroundColor = .systemTeal
        answerRightButtonOutlet.tintColor = .black
        answerRightButtonOutlet.layer.cornerRadius = 10.0
        nextQuestionButtonOutlet.backgroundColor = .systemTeal
        nextQuestionButtonOutlet.tintColor = .black
        nextQuestionButtonOutlet.layer.cornerRadius = 10.0
        nextQuestionButtonOutlet.setTitle("Next cat", for: .normal)
    }
}
