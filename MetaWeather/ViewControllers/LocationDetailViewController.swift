//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//  Swift 4.2 Version 
//

import UIKit

class LocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(WeatherForecastTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    public var city: City?
    private var forecasts: [Forecast]?
    
    // MARK: UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        guard let city = city else { return }
        title = city.title

        WeatherApiManager.sharedInstance.getWeatherDetailsForLocation(woeid: city.woeid) { (forecasts, error) in
            self.forecasts = forecasts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Setup
    
    private func setupViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = true

        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
    }
}

extension LocationDetailViewController {
    
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let forecasts = forecasts else {
            return 0
        }
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeatherForecastTableViewCell else {
            let cell = WeatherForecastTableViewCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
        
        guard let forecasts = self.forecasts else {
            return cell
        }
        
        let forecast = forecasts[indexPath.row]
        cell.setupWithForecast(forecast: forecast)
        cell.isUserInteractionEnabled = false
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
