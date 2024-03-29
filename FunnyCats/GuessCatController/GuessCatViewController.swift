//
//  GuessCatViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 01.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import Combine

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
    
    var subscriptions = Set<AnyCancellable>() //instance is used for to load data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // call setup and configure function
        configNavigationBar()
        setupController()
        configActivityIndicator()
        //load cat breeds
        loadCatBreeds()
        loadImageCat(catBreed: randomBreed(catBreeds: catBreeds))
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
        loadImageCat(catBreed: randomBreed(catBreeds: catBreeds))
        answerButtonsOutlet[0].backgroundColor = .systemTeal
        answerButtonsOutlet[1].backgroundColor = .systemTeal
        checkAnswerLable.text = "Let's do it!"
        answerButtonsOutlet[0].isEnabled = true
        answerButtonsOutlet[1].isEnabled = true
    }
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Guess cat"
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
    // random cat breed id
    func randomBreed(catBreeds: [CatBreedsDataBaseModel]) -> CatBreedsDataBaseModel {
        let randomBreed = Int.random(in: catBreeds.indices)
        indexCatBreeds = randomBreed
        let breed = catBreeds[randomBreed]
        // setup title answerButtonsOutlet
        let index = Int.random(in: 0...1)
        answerButtonsOutlet[index].setTitle(catBreeds[randomBreed].name, for: .normal)
        for answerButton in answerButtonsOutlet {
            if answerButton != answerButtonsOutlet[index] {
                answerButton.setTitle(catBreeds[Int.random(in: catBreeds.indices)].name, for: .normal)
            }
        }
        return breed
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
    // get photo using Combine
    func loadImageCat(catBreed: CatBreedsDataBaseModel) {
        
        activityIndicator.startAnimating()
        
        if let link = catBreed.image?.url, let url = URL(string: link) {
            
            //issue was configured that image was loaded by using Combine
            ImageLoader.shared.publisher(for: url).sink { [weak self] (image) in
                
                guard let self = self else { return }
                
                self.catImageView.image = image
                
            }.store(in: &self.subscriptions)
            
            self.activityIndicator.stopAnimating()
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
        answerButtonsOutlet[0].layer.cornerRadius = 5.0
        answerButtonsOutlet[1].backgroundColor = .systemTeal
        answerButtonsOutlet[1].tintColor = .black
        answerButtonsOutlet[1].layer.cornerRadius = 5.0
        nextQuestionButtonOutlet.backgroundColor = .systemTeal
        nextQuestionButtonOutlet.tintColor = .black
        nextQuestionButtonOutlet.layer.cornerRadius = 5.0
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
}
