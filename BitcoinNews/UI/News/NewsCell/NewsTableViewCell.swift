//
//  NewsTableViewCell.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    // MARK: - Constants
    
    private struct Constants {
        static let standartAnimationDuration: Double = 0.4
        static let standartNumberOfLines = 3
        static let backgroundViewRadius: CGFloat = 10
        static let placeholderImageName = "bitcoinPlaceholderImage"
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet private weak var infoBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    var showMoreAction: (() -> Void)?
    
    // MARK: - View life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoBackgroundView.layer.cornerRadius = Constants.backgroundViewRadius
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        showMoreButton.isHidden = !subtitleLabel.isTextTruncated
        UIView.animate(withDuration: Constants.standartAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup
    
    func setup(with model: PieceOfNews) {
        subtitleLabel.numberOfLines = Constants.standartNumberOfLines
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        setupImage(with: model.urlToImage)
    }
    
    // MARK: - Private
    
    private func setupImage(with url: String?) {
        newsImageView.image = nil
        guard let stringUrl = url, let url = URL(string: stringUrl) else {
            newsImageView.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        newsImageView.kf.setImage(with: url)
    }
    
    // MARK: - Action
    
    @IBAction func showMoreButtonAction(_ sender: Any) {
        guard let showMoreAction = showMoreAction else { return }
        showMoreAction()
    }
}
