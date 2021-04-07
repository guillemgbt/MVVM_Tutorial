//
//  Endpoints.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

/// Endpoint wrapper of the TMDb backend
struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path
        components.queryItems = addAPIKey(to: queryItems)

        return components.url
    }
    
    private func addAPIKey(to queryItems: [URLQueryItem]) -> [URLQueryItem] {
        let apiKeyItem = URLQueryItem(name: "api_key",
                                      value: "2a61185ef6a27f400fd92820ad9e8537")
        return queryItems + [apiKeyItem]
    }
}

/// Movie search endpoint
extension Endpoint {
    
    static func search(query: String) -> Endpoint {
        return Endpoint(
            path: "/3/search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query)
            ]
        )
    }
}
