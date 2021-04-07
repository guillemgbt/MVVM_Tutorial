//
//  URLResponse+Ext.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

extension URLResponse {
    
    func getStatusCode() -> Int {
        return (self as? HTTPURLResponse)?.statusCode ?? -1
    }
}
