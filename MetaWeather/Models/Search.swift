//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//

import Foundation

public class Search: NSObject, Codable {

    // MARK: Properties

    var searchWord: String
    var timeStamp: Double
    
    // MARK: Init

    init(searchWord: String, timeStamp: Double) {
        self.searchWord = searchWord
        self.timeStamp = timeStamp
    }
}
