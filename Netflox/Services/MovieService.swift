//
//  MovieService.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 01/04/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

protocol MovieServing {
    func search(query: String, onCompletion: @escaping ([Movie]?) -> Void)
    func toggleSave(movie: Movie, onCompletion: @escaping (Movie?) -> Void)
}

/// Service type class that handles the movie model fetching.
/// It decouples the fetching action from the modules that request the movies.
class MovieService: NSObject, MovieServing {
    
    private let api: API
    
    private var currentSearchTask: URLSessionDataTask? = nil
    
    init(api: API = API.shared) {
        self.api = api
        super.init()
    }
    
    func search(query: String, onCompletion: @escaping ([Movie]?) -> Void) {
        currentSearchTask?.cancel()

        currentSearchTask = api.GET(.search(query: query), onSuccess: { (data) in

            onCompletion(self.parseMovieResults(in: data))
            
        }) { (description) in
            
            Utils.printError(sender: self, message: description)
            onCompletion(nil)
        }
    }
    
    func toggleSave(movie: Movie, onCompletion: @escaping (Movie?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
            movie.saved.toggle()
            onCompletion(movie)
        }
    }
    
    private func parseMovieResults(in jsonData: [String:Any]) -> [Movie]? {
        
        guard let moviesJSON = jsonData["results"] as? [[String:Any]] else {
            return nil
        }
        
        return moviesJSON.compactMap{ Movie(from: $0) }
    }

}
