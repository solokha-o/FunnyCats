//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Oleksandr Solokha on 10.08.2021.
//  Copyright © 2021 Oleksandr Solokha. All rights reserved.
//

import UIKit
import Combine

public var cache = NSCache<NSURL, UIImage>()


class ImageLoader {
    
    
    static var shared = ImageLoader()
    
    func publisher(for url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Never.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            let urlSession = URLSession.shared
            return urlSession.dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse, userInfo: [
                        NSURLErrorFailingURLErrorKey: url
                    ])
                    }
                    return image
                }
                .catch { error in return Just(nil) }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [cache] image in
                    guard let image = image else { return }
                    cache.setObject(image, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}
