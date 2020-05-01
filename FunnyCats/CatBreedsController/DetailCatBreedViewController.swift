//
//  DetailCatBreedViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 30.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import WebKit

class DetailCatBreedViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    // create string with empty url
    var getUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrlCatBreed (passUrl: getUrl)
    }
    
    // load url from string in webView
    func loadUrlCatBreed (passUrl: String) {
        let url = NSURL(string: passUrl)
        webView.load(NSURLRequest(url: url! as URL) as URLRequest)
    }
}
