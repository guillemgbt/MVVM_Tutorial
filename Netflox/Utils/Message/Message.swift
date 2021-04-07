//
//  Message.swift
//  Netflox
//
//  Created by Budia Tirado, Guillem on 2/26/21.
//

import Foundation

class Message: Identifiable {
    let title: String
    let description: String?
    let id = UUID().uuidString
    
    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
}
