//
//  DetailCatBreedViewController.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 30.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import UIKit
import WebKit
import MapKit

class DetailCatBreedViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var mapView: MKMapView!
    
    var catBreed : CatBreedsDataBaseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setController()
    }
    
    // load url from string in webView
    private func loadUrlCatBreed(catBreed: CatBreedsDataBaseModel) {
        
        if let catBreed = self.catBreed, let link = catBreed.wikipediaURL, let url = URL(string: link) {
            webView.load(NSURLRequest(url: url) as URLRequest)
        }
    }
    
    //load location of cat origin
    private func loadLocationCatOrigin(catBreed: CatBreedsDataBaseModel) {
        LocationManager.getLocation(forPlaceCalled: catBreed.origin) { location in
            guard let location = location else { return }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = catBreed.origin
            annotation.subtitle = "Origin of \(catBreed.name)"
            
            let country = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 10000000, longitudinalMeters: 1000000)
            self.mapView.setRegion(country, animated: true)
            self.mapView.addAnnotation(annotation)
        }
    }
   
    private func setController() {
        if let catBreed = self.catBreed {
            loadUrlCatBreed(catBreed: catBreed)
            loadLocationCatOrigin(catBreed: catBreed)
            navigationItem.title = catBreed.name
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
}
