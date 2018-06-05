//
//  NetworkHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

enum FeedFetcherError : Error {
    case couldNotTranslateUrl
    case insufficientDataToProceed
}

protocol FeedFetcherProtocol : class {
    
    func start(withUrl url: String,
               completion: @escaping NetworkCallback)
    
}

class FeedFetcher : FeedFetcherProtocol {
    
    // MARK: Class members
    
    static let shared: FeedFetcher = {
        return FeedFetcher()
    }()
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Operations

    func start(withUrl url: String,
               completion: @escaping NetworkCallback) {
        
        let sesion = URLSession(configuration: .default)
        
        guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString) else {
            completion(nil, FeedFetcherError.couldNotTranslateUrl)
            return
        }
        
        let task = sesion.dataTask(with: url) { (data, urlResponse, error) in
            if let data = data {
                do {
                    let jsonDic = try JSONSerialization.jsonObject(with: data,
                                                                   options: JSONSerialization.ReadingOptions.mutableContainers)
                    DispatchQueue.main.async {
                        completion(jsonDic as? RegularDictionary, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else {
                let error = FeedFetcherError.insufficientDataToProceed
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
}
