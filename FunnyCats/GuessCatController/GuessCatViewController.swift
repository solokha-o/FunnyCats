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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        setupController()
    }
    
    @IBAction func answerLeftButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func answerRightButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func nextQuestionButtonAction(_ sender: UIButton) {
    }
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Guess cat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
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
