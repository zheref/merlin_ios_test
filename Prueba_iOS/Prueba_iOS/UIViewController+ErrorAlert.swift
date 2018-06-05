//
//  UIViewController+ErrorAlert.swift
//  Prueba_iOS
//
//  Created by Sergio Daniel L. García on 6/4/18.
//  Copyright © 2018 Humberto Cetina. All rights reserved.
//

import UIKit

typealias Callback = () -> Void

extension UIViewController {
    
    func presentAlert(forError error: Error, withCompletion completion: Callback? = nil) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completion?()
        }))
        
        alert.show(self, sender: nil)
    }
    
}
