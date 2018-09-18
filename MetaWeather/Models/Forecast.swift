//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import Foundation

public struct Forecast {
    
    // MARK: Properties

    let weatherStateName: String
    let applicableDate: String
    let minTemp: Int
    let maxTemp: Int
    
    // MARK: Init

    init?(jsonDictionary: Dictionary<String, Any>) {
        
        guard let weatherStateName = jsonDictionary["weather_state_name"] as? String,
            let applicableDate = jsonDictionary["applicable_date"] as? String,
            let minTemp = jsonDictionary["min_temp"] as? Double,
            let maxTemp = jsonDictionary["max_temp"] as? Double else {
                return nil
        }
    
        // Used to change the temperature to Fahrenheit because API returns Celsius
        func temperatureInFahrenheit(temperature: Double) -> Double {
            let fahrenheitTemperature = temperature * 9 / 5 + 32
            return fahrenheitTemperature
        }
        
        self.weatherStateName = weatherStateName
        self.applicableDate = applicableDate
        self.minTemp = Int(round(temperatureInFahrenheit(temperature: minTemp)))
        self.maxTemp = Int(round(temperatureInFahrenheit(temperature: maxTemp)))
    }
}
