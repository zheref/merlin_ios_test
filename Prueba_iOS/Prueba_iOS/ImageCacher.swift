//
//  ImageCacheHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

protocol ImageCacherProtocol : class {
    
    func image(forUrlString urlString: String,
               completion: @escaping (_ image: UIImage?) -> Void)
    
}

class ImageCacher : ImageCacherProtocol {
    
    // MARK: Class members
    
    static let shared: ImageCacherProtocol = {
        return ImageCacher()
    }()
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Private operations

    private func imageName(fromUrlString urlString: String) -> String? {
        let urlSeparated = urlString.components(separatedBy: "/")
        return urlSeparated.last
    }
    
    // MARK: Operations
    
    func image(forUrlString urlString: String,
               completion: @escaping (_ image: UIImage?) -> Void) {
        
        let tmpFolderUrl = URL(fileURLWithPath: NSTemporaryDirectory(),
                               isDirectory: true)
        
        if let imageName = imageName(fromUrlString: urlString) {
            let imageUrl = tmpFolderUrl.appendingPathComponent(imageName)
            
            if let cacheImage = UIImage(contentsOfFile: imageUrl.path) {
                completion(cacheImage)
                return
            }
            
            let sesion = URLSession(configuration: URLSessionConfiguration.default)
            
            guard let imageNameEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let imageServerUrl = URL(string: imageNameEncoded) else {
                    completion(nil)
                    return
            }
            
            let task = sesion.dataTask(with: imageServerUrl) { (data, urlResponse, error) in
                try! data!.write(to: imageUrl)
                
                if let data = data,
                    let imageToCache = UIImage(data: data) {
                    completion(imageToCache)
                } else {
                    completion(nil)
                }
            }
            
            task.resume()
        } else {
            completion(nil)
        }
    }
}
