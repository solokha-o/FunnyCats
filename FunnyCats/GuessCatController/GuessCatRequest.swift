//
//  GuessCatRequest.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 02.05.2020.
//  Copyright © 2020 Oleksandr Solokha. All rights reserved.
//

import Foundation

struct GuessCatRequest {
    
    let session = URLSession.shared
    // load cat breed from url
    func loadCat(breedId: String, completion: @escaping (([GuessCatDataBaseModel]) -> Void)) {
        // url and request whit api key
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_id=" + breedId) else { return }
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
                    let response = try decoder.decode([GuessCatDataBaseModel].self, from: data)
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
