//
//  NetworkHandler.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

class NetworkHandler: NSObject {

    func jSonWith(_ url: String, andReturn block:@escaping (_ dic: Dictionary<String, Any>?, _ error: Error?) -> Void) {
        
        let sesion: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let set: CharacterSet = CharacterSet.urlQueryAllowed
        let encondedUrlString: String = url.addingPercentEncoding(withAllowedCharacters: set)!
        let url: URL = URL(string: encondedUrlString)!
        
        let task: URLSessionDataTask = sesion.dataTask(with: url) { (data, urlResponse, error) in
            
            do
            {
                let jsonDic: Any = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                block(jsonDic as? Dictionary<String, Any>, nil);
            }
            catch
            {
                block(nil, nil);
            }
        };
        
        task.resume();
    }
}
