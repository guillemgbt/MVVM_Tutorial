//
//  ImageCache.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 02/04/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

/// Retrieve, store and delete cached images using NSCache. Accessing by subscript.
class ImageCache: NSObject {

    private lazy var imageCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    //Using lock in read-write cache operations to ensure
    //that a single thread is accessing at anytime and
    //make it thread safe
    private let lock = NSLock()
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return addImage(newValue, for: key)
        }
    }
    
    private func addImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as NSURL)
    }

    private func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as NSURL)
    }
    
    private func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        
        return imageCache.object(forKey: url as NSURL)
    }
    
}
