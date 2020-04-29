//
//  GetCatBreedsRequest.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 29.04.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation

struct GetCatBreedsRequest {
    
    let session = URLSession.shared
    // get cat breeds from url
    func getCatBreeds(completion: @escaping (([CatBreedsDataBaseModel]) -> Void)) {
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
            default:
                print(response.statusCode)
            }
        })
        task.resume()
    }
}

