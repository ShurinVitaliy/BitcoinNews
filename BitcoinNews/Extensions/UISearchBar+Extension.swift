//
//  UISearchBar+Extension.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setTextFieldColor(color: UIColor, textColor: UIColor) {
        self.searchTextField.backgroundColor = color
        self.searchTextField.textColor = textColor
        self.searchTextField.tintColor = .darkGray
    }
}
