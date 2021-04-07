//
//  ImageLoader.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 02/04/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

/// Interface to fetch images in cache or network. Stores image in cache once fetched from the network.
class ImageLoader: NSObject {
    
    static let shared = ImageLoader()
    
    private let cache: ImageCache
    private let urlSession: URLSession
    
    init(cache: ImageCache = ImageCache(), urlSession: URLSession = URLSession.shared) {
        self.cache = cache
        self.urlSession = urlSession
        super.init()
    }
    
    /// Loads image from network or cache
    /// - Parameters:
    ///   - url: resource url
    ///   - onCompletion: callback when resource loaded or error happened
    func load(_ url: URL, onCompletion: @escaping (UIImage?)->()) {
        
        if let image = cache[url] {
            onCompletion(image)
            return
        }
        
        urlSession.dataTask(with: url) { [weak self] (data, _, error) in
            
            guard let data = data, let img = UIImage(data: data), error == nil else {
                Utils.printError(sender: self, message: error?.localizedDescription ?? "No Data")
                onCompletion(nil)
                return
            }
            
            self?.cache[url] = img
            
            onCompletion(img)
        }.resume()
    }
    
    /// Loads image from network or cache and handles the completion on the  main thread
    /// - Parameters:
    ///   - url: resource url
    ///   - onCompletion: callback when loading is done
    func loadToUI(_ url: URL, onCompletion: @escaping (UIImage?)->()) {
        
        let onCompletionUI: (UIImage?)->() = { image in
            DispatchQueue.main.async {
                onCompletion(image)
            }
        }
        
        load(url, onCompletion: onCompletionUI)
    }

}
