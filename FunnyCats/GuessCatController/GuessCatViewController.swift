//
//  GuessCatViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 01.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit

class GuessCatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    // configure NavigationBar
    func configNavigationBar() {
        navigationItem.title = "Guess cat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .systemTeal
        navigationController?.navigationBar.barTintColor = .systemTeal
    }
}
