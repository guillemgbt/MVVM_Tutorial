//
//  ImageURL.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

/// Image url wrapper of the TMDb backend
struct ImageURL {
    private let baseURL: String = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    private let path: String
    
    var url: URL? {
        guard let strURL = (baseURL+path)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
        return URL(string: strURL)
    }
    
    /// Prepares the complete poster URL for a given poster path
    /// - Parameter path: poster path
    /// - Returns: poster url
    static func posterURL(path: String) -> ImageURL {
        return ImageURL(path: path)
    }
}
