//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, SearchViewControllerDelegate {
    
    // MARK: Properties

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 10.0
        return locationManager
    }()

    private var cities: [City]?
    private var lastLocation: CLLocation?
    
    // MARK: UIViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Current Location"
        setupViews()

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Setup Methods
    
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchViewController))

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

    // MARK: Private Methods

    @objc private func showSearchViewController() {
        let searchNavigationController = UINavigationController()
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        searchNavigationController.viewControllers = [searchViewController]
        navigationController?.present(searchNavigationController, animated: true, completion: nil)
    }
    
    private func showNoResultsAlert() {
        let alertController = UIAlertController(title: "No results", message: "Search for another place.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func showNeedLocationAlert() {
        let alertController = UIAlertController(title: "Need location access", message: "You need to grant location permissions in Settings app.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func getLocation(latitude: String, longitude: String) {
        WeatherApiManager.sharedInstance.getLocationsFor(latitude: latitude, longitude: longitude) { [unowned self] (cities, error) in
            self.cities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getLocation(searchTerm: String) {
        WeatherApiManager.sharedInstance.getLocationsFor(query: searchTerm) { [unowned self] (cities, error) in
            self.cities = cities
            DispatchQueue.main.async {
                // show alert if there are no cities returned to tell user to search again
                if self.cities?.count == 0 {
                    self.showNoResultsAlert()
                }
                self.tableView.reloadData()
            }
        }
    }
}


extension ViewController {
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cities = cities else {
            return 0
        }
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LocationTableViewCell else {
            let cell = LocationTableViewCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
            
        guard let cities = self.cities else {
            return cell
        }
        
        let city = cities[indexPath.row]
        cell.setupWithCity(city: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities?[indexPath.row]
        let locationDetailViewController = LocationDetailViewController()
        locationDetailViewController.city = city
        navigationController?.show(locationDetailViewController, sender: self)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        
        // Don't want to update the location list every time location updates.
        // This causes an error where user searches by keyword but the current location
        // updates and then this is calledand the search results are updated.
        if lastLocation == nil {
            guard let lastLocation = locations.last else { return }
            self.lastLocation = lastLocation
            let latitude = lastLocation.coordinate.latitude
            let longitude = lastLocation.coordinate.longitude
            getLocation(latitude: String(latitude), longitude: String(longitude))
        }
    }
    
    // MARK: SearchViewControllerDelegate
    
    func searchWithTerm(_ searchTerm: String) {
        title = searchTerm
        getLocation(searchTerm: searchTerm)
    }

    func searchCurrentLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showNeedLocationAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                return
            }
        } else {
            showNeedLocationAlert()
        }
        
        guard let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude else { return }
        title = "Current Location"
        getLocation(latitude: String(latitude), longitude: String(longitude))
    }
}

