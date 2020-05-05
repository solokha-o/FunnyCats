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
    @IBOutlet var answerButtonsOutlet: [UIButton]!
    @IBOutlet weak var nextQuestionButtonOutlet: UIButton!
    @IBOutlet weak var scoreLable: UILabel!
    // create enum for answer true or false
    enum Answer {
        case trueAnswer, falseAnswer
        
        var answerLabel: String {
            switch self {
            case .trueAnswer: return "You are right 👍"
            case .falseAnswer: return "You are wrong 👎"
            }
        }
        var colorButton: UIColor {
            switch self {
            case .trueAnswer: return .green
            case .falseAnswer: return .red
            }
        }
    }
    let trueAnswer = Answer.trueAnswer
    let falseAnswer = Answer.falseAnswer
    
    // create array of cat breeds
    var catBreeds = [CatBreedsDataBaseModel]()
    // add instance of GetCatBreedsRequest
    let getCatBreeds = GetCatBreedsRequest()
    //add instance of GuessCatRequest
    let guessCatRequest = GuessCatRequest()
    //create instance guess cat model
    var guessCat = [GuessCatDataBaseModel]()
    // create activity indicator
    var activityIndicator = UIActivityIndicatorView()
    // check index array catBreeds
    var indexCatBreeds = 0
    //instanсe count score right answer
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call setup and configure function
        configNavigationBar()
        setupController()
        configActivityIndicator()
        //load cat breeds
        self.getCatBreeds.loadCatBreeds { [weak self] catBreeds in
            self?.catBreeds = catBreeds
            self?.loadImageCatBreed(catBreeds: catBreeds)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // configure answer buttons
    @IBAction func answerButtonAction(_ sender: UIButton) {
        var ansverIsRight : Bool {
            return sender.titleLabel?.text == catBreeds[indexCatBreeds].name
        }
        
        switch ansverIsRight {
        case true:
            sender.backgroundColor = trueAnswer.colorButton
            checkAnswerLable.text = trueAnswer.answerLabel
            score += 1
        case false:
            sender.backgroundColor = falseAnswer.colorButton
            checkAnswerLable.text = falseAnswer.answerLabel
        }
        answerButtonsOutlet[0].isEnabled = false
        answerButtonsOutlet[1].isEnabled = false
        scoreLable.text = "Score: \(score)"
    }
    // configure next question button by use random breed
    @IBAction func nextQuestionButtonAction(_ sender: UIButton) {
        loadImageCatBreed(catBreeds: self.catBreeds)
        answerButtonsOutlet[0].backgroundColor = .systemTeal
        answerButtonsOutlet[1].backgroundColor = .systemTeal
        checkAnswerLable.text = "Let's do it!"
        answerButtonsOutlet[0].isEnabled = true
        answerButtonsOutlet[1].isEnabled = true
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
        indexCatBreeds = randomBreed
        let breedId = catBreeds[randomBreed].id
        // setup title answerButtonsOutlet
        let index = Int.random(in: 0...1)
        answerButtonsOutlet[index].setTitle(catBreeds[randomBreed].name, for: .normal)
        for answerButton in answerButtonsOutlet {
            if answerButton != answerButtonsOutlet[index] {
                answerButton.setTitle(catBreeds[Int.random(in: catBreeds.indices)].name, for: .normal)
            }
        }
        return breedId
    }
    // load image cat breed
    func loadImageCatBreed(catBreeds: [CatBreedsDataBaseModel]) {
        activityIndicator.startAnimating()
        guessCatRequest.loadCat(breedId: randomBreed(catBreeds: catBreeds)) { [weak self] guessCat in
            DispatchQueue.main.async {
                self?.guessCat = guessCat
                guard let url = URL(string: guessCat[0].url) else { return }
                self?.catImageView.load(url: url)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    // configure controller
    func setupController() {
        guessCatLable.text = "Guess the breed by the photo"
        catImageView.contentMode = .scaleAspectFill
        catImageView.layer.masksToBounds = true
        catImageView.layer.cornerRadius = 20.0
        answerButtonsOutlet[0].backgroundColor = .systemTeal
        answerButtonsOutlet[0].tintColor = .black
        answerButtonsOutlet[0].layer.cornerRadius = 10.0
        answerButtonsOutlet[1].backgroundColor = .systemTeal
        answerButtonsOutlet[1].tintColor = .black
        answerButtonsOutlet[1].layer.cornerRadius = 10.0
        nextQuestionButtonOutlet.backgroundColor = .systemTeal
        nextQuestionButtonOutlet.tintColor = .black
        nextQuestionButtonOutlet.layer.cornerRadius = 10.0
        nextQuestionButtonOutlet.setTitle("Next cat", for: .normal)
        checkAnswerLable.text = "Let's do it!"
        scoreLable.text = "Score: \(score)"
    }
    // configure activity Indicator
    func configActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.layer.cornerRadius = 10.0
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = .systemTeal
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
//    func setupTitleAnswerButton(catBreeds: [CatBreedsDataBaseModel], guessCat: [GuessCatDataBaseModel]) {
//        let index = Int.random(in: 0...1)
//        answerButtonsOutlet[index].setTitle(guessCat[0]., for: <#T##UIControl.State#>)
//    }
}
