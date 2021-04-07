//
//  Utils.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

class Utils: NSObject {

    static func printDebug(sender: AnyObject?, message: Any){
        if let _sender = sender {
            print("["+String(describing: type(of: _sender))+"]: \(message)")
        } else {
            print("[]: \(message)")
        }
    }
    
    static func printError(sender: AnyObject?, message: Any){
        if let _sender = sender {
            print("ERROR! -> ["+String(describing: type(of: _sender))+"]: \(message)")
        } else {
            print("ERROR! -> []: \(message)")
        }
    }
}
