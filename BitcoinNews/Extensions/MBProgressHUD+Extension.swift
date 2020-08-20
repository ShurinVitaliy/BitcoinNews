//
//  MBProgressHUD+Extension.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    func hideError(message: String = "Something went wrong.",
                   afterDelay: Double = 1) {
        isUserInteractionEnabled = false
        mode = .text
        label.textColor = UIColor.red
        label.text = message
        label.numberOfLines = 0
        hide(animated: true, afterDelay: afterDelay)
    }
}
