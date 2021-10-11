//
//  Book.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-19.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import Foundation

class Book : NSObject, Codable {
    
    var pages = [Page]()
    var bookTitle = String()
}
