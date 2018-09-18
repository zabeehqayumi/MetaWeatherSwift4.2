//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
////

public struct City {
    
    // MARK: Properties

    let distance: Int?
    let title: String
    let locationType: String
    let woeid: Int
    let lattLong: String
    
    // MARK: Init

    init?(jsonDictionary: Dictionary<String, Any>) {
        
        guard let title = jsonDictionary["title"] as? String,
            let locationType = jsonDictionary["location_type"] as? String,
            let woeid = jsonDictionary["woeid"] as? Int,
            let lattLong = jsonDictionary["latt_long"] as? String else {
                return nil
        }
        
        if let distance = jsonDictionary["distance"] as? Int {
            self.distance = distance
        } else {
            self.distance = nil
        }
        
        self.title = title
        self.locationType = locationType
        self.woeid = woeid
        self.lattLong = lattLong
    }
}
