//
//  SearchTableViewController.swift
//  Volvo Cars
//
//  Created by Zabeehullah Qayumi on 9/18/18.
//  Copyright © 2018 Zabeehullah Qayumi. All rights reserved.
//
//

import UIKit

class DateHandler: NSObject {
    
    // MARK: Properties

    public static let sharedInstance = DateHandler()
    private let dateFormatter: DateFormatter
    
    // MARK: Init method

    override init() {
        dateFormatter = DateFormatter()
    }
    
    // MARK: Public functions
    
    // Returns the provided date as a day of the week
    public func dayOfWeek(dateString: String) -> String? {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
