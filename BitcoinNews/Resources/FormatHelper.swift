//
//  FormatHelper.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import Foundation

class FormatHelper {
    class func dateFormatter(format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    class func dateToString(from date: Date?, dateFormat: String = "yyyy-MM-dd") -> String {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
