//
//  SearchTableViewController.swift
//  Volvo Cars
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import XCTest
@testable import MetaWeather

class MetaWeatherTests: XCTestCase {

    func testFahrenheitConversionWorking() {

        let forecastDictionary : [String: Any] = ["min_temp": 19.6975,
                                                      "max_temp": 22.495,
                                                      "applicable_date": "2018-08-19",
                                                      "weather_state_name": "Showers"]
        
        let forecast = Forecast(jsonDictionary: forecastDictionary)
        
        XCTAssertEqual(forecast?.maxTemp, 72, "Fahrenheit conversion worked")
     }
    
}
