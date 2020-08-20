//
//  UILabel+Extension.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 20.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

extension UILabel {
    var isTextTruncated: Bool {
        self.layoutIfNeeded()
        let textBoundingRect = text?.boundingRect(with: CGSize(width: bounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil).size.height ?? 0
        return textBoundingRect >= bounds.size.height
    }
}
