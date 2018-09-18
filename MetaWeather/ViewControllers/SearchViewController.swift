//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func searchWithTerm(_ searchTerm: String)
    func searchCurrentLocation()

}
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    // MARK: Properties

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        return searchBar
    }()
    
    weak var delegate: SearchViewControllerDelegate?
    private var searches: [Search]?
    
    // MARK: UIViewController Lifecycle Methods

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Get saved searches from UserDefaults.
        // Given more time, I would create a separate class to manage this.
        if let savedSearchs = UserDefaults.standard.object(forKey: "searches") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                let unsortedSearches = try jsonDecoder.decode([Search].self, from: savedSearchs)
                searches = unsortedSearches.sorted(by: { $0.timeStamp > $1.timeStamp })
            } catch {
                print("Failed to load searchs")
            }
        } else {
            searches = [Search]()
        }
        
        setupViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save the searches.
        save()
    }
    
    // MARK: Setup Methods
    
    private func setupViews() {
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissSearchViewController))
        
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
    
    @objc func dismissSearchViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func useCurrentLocation() {
        dismiss(animated: true) {
            self.delegate?.searchCurrentLocation()
        }
    }
    
    private func save() {
        // Save searches to UserDefaults.
        // Given more time, I would create a separate class to manage this.
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(searches) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "searches")
        } else {
            print("Failed to save search terms.")
        }
    }
}

extension SearchViewController {
    
    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searches = searches else {
            return 0
        }
        return searches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let searches = self.searches else {
            return cell
        }
        let search = searches[indexPath.row]
        
        cell.textLabel?.text = search.searchWord
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            searches?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Create header that user can tap to search for their current location.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        let currentLocationButton = UIButton(type: .custom)
        currentLocationButton.addTarget(self, action: #selector(useCurrentLocation), for: .touchUpInside)
        currentLocationButton.setTitle("Your Current Location", for: .normal)
        currentLocationButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        currentLocationButton.setTitleColor(.black, for: .normal)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(currentLocationButton)
        headerView.backgroundColor = .lightGray
        currentLocationButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        currentLocationButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let search = searches?[indexPath.row] else { return }
        dismiss(animated: true) {
            self.delegate?.searchWithTerm(search.searchWord)
        }
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        let timeStamp = Date().timeIntervalSinceReferenceDate
        let search = Search(searchWord: searchTerm, timeStamp: timeStamp)
        searches?.append(search)
        
        dismiss(animated: true) {
            self.delegate?.searchWithTerm(searchTerm)
        }
    }
}
