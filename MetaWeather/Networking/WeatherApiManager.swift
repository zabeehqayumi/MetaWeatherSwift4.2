//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit

class WeatherApiManager: NSObject {
    
    private struct WeatherApiConstants{
        static let baseUrl = "https://www.metaweather.com/api/location/"
        static let latLongSearch = "search/?lattlong="
        static let querySearch = "search/?query="
    }
    
    private enum WeatherAPIErrorManager: Error {
        case error
    }
    
    public static let sharedInstance = WeatherApiManager()
    
    public func getLocationsFor(latitude: String, longitude: String, completionHandler: @escaping ([City]?, Error?) -> Void) {
        
        let url = WeatherApiConstants.baseUrl + WeatherApiConstants.latLongSearch + "\(latitude),\(longitude)"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    
                    guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>] else {
                        throw WeatherAPIErrorManager.error
                    }
                    
                    var cityModels = [City]()
                    for cityDictionary in object {
                        if let city = City(jsonDictionary: cityDictionary) {
                            cityModels.append(city)
                        }
                    }

                    completionHandler(cityModels, nil)
                    return
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
        
        task.resume()
    }
    
    public func getLocationsFor(query: String, completionHandler: @escaping ([City]?, Error?) -> Void) {
        
        guard let escapingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let url = WeatherApiConstants.baseUrl + WeatherApiConstants.querySearch + "\(escapingQuery)"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    
                    guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>] else {
                        throw WeatherAPIErrorManager.error
                    }
                    
                    var cityModels = [City]()
                    for cityDictionary in object {
                        if let city = City(jsonDictionary: cityDictionary) {
                            cityModels.append(city)
                        }
                    }
                    
                    completionHandler(cityModels, nil)
                    return
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
        
        task.resume()
    }
    
    public func getWeatherDetailsForLocation(woeid: Int, completionHandler: @escaping ([Forecast]?, Error?) -> Void) {
        
        let url = WeatherApiConstants.baseUrl + "\(woeid)"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    
                    guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>,
                        let weatherForecastsDictionary = object["consolidated_weather"] as? [Dictionary<String, Any>] else {
                        throw WeatherAPIErrorManager.error
                    }
                    
                    var forecastModels = [Forecast]()
                    for forecastDictionary in weatherForecastsDictionary {
                        if let forecast = Forecast(jsonDictionary: forecastDictionary) {
                            forecastModels.append(forecast)
                        }
                    }
                    
                    completionHandler(forecastModels, nil)
                    return
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
        
        task.resume()
    }

}
