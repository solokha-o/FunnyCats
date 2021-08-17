//
//  DataLoader.swift
//  FunnyCats
//
//  Created by Oleksandr Solokha on 14.08.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import Foundation
import Combine

struct Constant {
    static let linkLoadCatBreeds = "https://api.thecatapi.com/v1/breeds"
    static let yourAuthorizationToken = "81be8538-14ea-424c-8677-0bb419c7b7ba"
    static let httpHeaderField = "x-api-key"
}

enum HTTPMetod: String {
    case get = "GET"
}

enum HTTPError: LocalizedError {
    case statusCode
}

class DataLoader {
    
    static  func loadData<T: Decodable>(link: String) -> AnyPublisher<T, Error> {
        
        let session = URLSession.shared
        
        guard let url = URL(string: link) else { let error = URLError(.badURL, userInfo: [NSURLErrorKey: link])
            return Fail(error: error).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMetod.get.rawValue
        request.addValue(Constant.yourAuthorizationToken, forHTTPHeaderField: Constant.httpHeaderField)
        
        return session.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .tryMap { output -> T in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return try JSONDecoder().decode(T.self, from: output.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()        
    }
}
