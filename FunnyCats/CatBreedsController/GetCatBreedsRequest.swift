//
//  GetCatBreedsRequest.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation
import UIKit

struct GetCatBreedsRequest {
    
    let session = URLSession.shared
    // load cat breeds from url
    func loadCatBreeds(completion: @escaping (([CatBreedsDataBaseModel]) -> Void)) {
        // url and request whit api key
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else { return }
        var reguest = URLRequest(url: url)
        let yourAuthorizationToken = "81be8538-14ea-424c-8677-0bb419c7b7ba"
        reguest.httpMethod = "GET"
        reguest.addValue(yourAuthorizationToken, forHTTPHeaderField: "x-api-key")
        // create dataTask
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            switch response.statusCode {
            case 200:
                guard let data = data else { return }
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode([CatBreedsDataBaseModel].self, from: data)
                    print(response)
                    DispatchQueue.main.async {
                        completion(response)
                    }
                } catch {
                    print(error.localizedDescription)
                }
//            case 408:
//                let alert = UIAlertController(title: "Attention!", message: "Please, check your internet connection and try yet!", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                UIApplication.topViewController()?.presentingViewController?.present(alert, animated: true, completion: nil)
            default:
                print(response.statusCode)
            }
        })
        task.resume()
    }
}
//extension UIApplication {
//
//    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
//        if let nav = base as? UINavigationController {
//            return topViewController(base: nav.visibleViewController)
//        }
//        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
//            return topViewController(base: selected)
//        }
//        if let presented = base?.presentedViewController {
//            return topViewController(base: presented)
//        }
//        return base
//    }
//}

