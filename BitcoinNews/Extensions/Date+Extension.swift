//
//  Date+Extension.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date { return Date().dayBefore }
    func someDaysAgoDate(_ count: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -count, to: noon)!
    }
    
    private var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    private var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    private var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
}

