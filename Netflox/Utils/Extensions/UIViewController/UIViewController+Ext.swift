//
//  UIViewController+Ext.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Extension to show alert view given a message
    func show(message: Message, onCompletion: (() -> ())? = nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: message.title,
                                                    message: message.description,
                                                    preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertAction.Style.default,
                                                    handler: {alert in
                onCompletion?()
            }))
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
}
