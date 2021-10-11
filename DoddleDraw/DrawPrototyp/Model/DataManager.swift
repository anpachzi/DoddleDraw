//
//  DataManager.swift
//  DrawPrototyp
//
//  Created by Andreas Zikovic on 2018-06-26.
//  Copyright © 2018 Andreas Zikovic. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager()
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(SavedBooksController.library) {
            UserDefaults.standard.set(encoded, forKey: "library")
            UserDefaults.standard.synchronize()
        }
    }
    
    func load() {
        if let libraryData = UserDefaults.standard.value(forKey: "library") as? Data {
            let decoder = JSONDecoder()
            if let books = try? decoder.decode(Array.self, from: libraryData) as [Book] {
                SavedBooksController.library = books
            }
        }
    }
}
