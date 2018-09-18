//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: Properties

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        return titleLabel
    }()
    
    private let typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        typeLabel.textAlignment = .right
        return typeLabel
    }()
    
    private let idLabel: UILabel = {
        let idLabel = UILabel()
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        return idLabel
    }()

    // MARK: Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    // MARK: Setup

    public func setupWithCity(city: City) {
        titleLabel.text = city.title
        typeLabel.text = "Type: " + city.locationType
        idLabel.text = "ID: " + String(city.woeid)
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(idLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            typeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),

            idLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 15),
            idLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            ])
    }
    
}
