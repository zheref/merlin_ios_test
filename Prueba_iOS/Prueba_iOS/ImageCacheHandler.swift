//
//  ImageCacheHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class ImageCacheHandler: NSObject {

    func imageNameFrom(urlString: String) -> String? {
        let urlSeparated = urlString.components(separatedBy: "/")
        return urlSeparated.last
    }
    
    func imageFor(urlString: String, andReturn block: @escaping (_ image: UIImage?) -> Void) {
        let tmpFolderUrl: URL = URL.init(fileURLWithPath: NSTemporaryDirectory(),
                                         isDirectory: true)
        
        if let imageName = imageNameFrom(urlString: urlString) {
            let imageUrl: URL = tmpFolderUrl.appendingPathComponent(imageName)
            
            if let cacheImage = UIImage(contentsOfFile: imageUrl.path) {
                block(cacheImage)
                return
            }
                
            let sesion = URLSession(configuration: URLSessionConfiguration.default)
            let set = CharacterSet.urlQueryAllowed
            let imageNameEncoded = urlString.addingPercentEncoding(withAllowedCharacters: set)!
            let imageServerUrl: URL? = URL(string: imageNameEncoded)
            
            if let imageServerUrl = imageServerUrl {
                let task: URLSessionDataTask = sesion.dataTask(with: imageServerUrl) { (data, urlResponse, error) in
                    try! data!.write(to: imageUrl)
                    let imageToCache = UIImage(data: data!)
                    
                    block(imageToCache)
                }
                
                task.resume()
            } else {
                block(nil)
            }
        } else {
            block(nil)
        }
    }
}
