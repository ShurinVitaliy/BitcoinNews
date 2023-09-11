//
//  NSError+extension.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import Foundation

extension NSError {
    static func error(with description: String) -> NSError {
        return NSError(domain: "BitcoinNews", code: -1, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

//Test 1
