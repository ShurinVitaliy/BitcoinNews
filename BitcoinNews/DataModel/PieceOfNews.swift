//
//  PieceOfNews.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

final class NewsModel: Codable {
    let articles: [PieceOfNews]?
}

final class PieceOfNews: Codable {
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}
