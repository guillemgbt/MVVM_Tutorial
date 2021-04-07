//
//  Movie.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 01/04/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import UIKit

/// TMDb movie information model representation
class Movie {
    
    private let id: Int
    private let original_title: String
    private let overview: String?
    private let poster_path: String?
    private let popularity: Double?
    var saved: Bool = false
    
    init(id: Int,
         original_title: String,
         overview: String?,
         poster_path: String?,
         popularity: Double?) {
        
        
        self.id = id
        self.original_title = original_title
        self.overview = overview
        self.poster_path = poster_path
        self.popularity = popularity
    }
    
    // Contitional initialisation making sure the Id and the title exists
    convenience init?(from json: [String:Any]) {
        guard let id = json["id"] as? Int,
            let title = json["original_title"] as? String else {
                return nil
        }
        
        self.init(id: id,
                  original_title: title,
                  overview: json["overview"] as? String,
                  poster_path: json["poster_path"] as? String,
                  popularity: json["popularity"] as? Double)
    }
    
    func getID() -> Int {
       return id
    }
    
    func getTitle() -> String {
        return original_title
    }
    
    func getOverview() -> String? {
        return overview
    }
    
    func getPopularity() -> Double? {
        return popularity
    }
    
    func getPosterURL() -> URL? {
        
        guard let poster = self.poster_path else {
            return nil
        }
        
        return ImageURL.posterURL(path: poster).url
    }
    
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
