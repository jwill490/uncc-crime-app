
//
//  StringTricks.swift
//  mapTesting2
//
//  Created by Dallas Sanchez on 11/23/15.
//  Copyright © 2015 Dallas Sanchez. All rights reserved.
//

import Foundation


extension String{
    func exclude(find:String) -> String {
        return stringByReplacingOccurrencesOfString(find, withString: "", options: .LiteralSearch, range: nil)
    }
    func replaceAll(find:String, with:String) -> String {
        return stringByReplacingOccurrencesOfString(find, withString: with, options: .LiteralSearch, range: nil)
    }
}