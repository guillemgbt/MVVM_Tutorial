//
//  UIImageView+Ext.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 02/04/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit


/*
 Useful UIImageView extension to load network images
 using the ImageLoader class
 */
extension UIImageView {
    
    func loadImage(image: UIImage?) {
        self.image = image
    }
    
    func loadImage(from url: URL?, placeholder: UIImage? = nil) {
        
        loadImage(image: placeholder)
        
        guard let url = url else {
            return
        }
        
        //Request image with main thread callback
        ImageLoader.shared.loadToUI(url) { [weak self] (image) in
            if let image = image {
                self?.loadImage(image: image)
            }
        }
    }
    
}
