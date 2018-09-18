//
//  SearchTableViewController.swift
//  MetaWeather
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {

    // MARK: Properties

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return dateLabel
    }()
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    private let highTempLabel: UILabel = {
        let highTempLabel = UILabel()
        highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        highTempLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return highTempLabel
    }()
    
    private let lowTempLabel: UILabel = {
        let lowTempLabel = UILabel()
        lowTempLabel.textColor = .gray
        lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTempLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        return lowTempLabel
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

    public func setupWithForecast(forecast: Forecast) {
        
        // Convert date string to day of week
        if let dateString = DateHandler.sharedInstance.dayOfWeek(dateString: forecast.applicableDate) {
            dateLabel.text = dateString
        }

        // Every weather state name has an image with the same name to show for that state.
        iconImageView.image = UIImage(named: forecast.weatherStateName)
        highTempLabel.text = String(forecast.maxTemp)
        lowTempLabel.text = String(forecast.minTemp)
    }
    
    private func setupSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(highTempLabel)
        contentView.addSubview(lowTempLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lowTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            lowTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            highTempLabel.trailingAnchor.constraint(equalTo: lowTempLabel.leadingAnchor, constant: -15),
            highTempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 30.0),
            iconImageView.widthAnchor.constraint(equalToConstant: 30.0),

            ])
    }
}
