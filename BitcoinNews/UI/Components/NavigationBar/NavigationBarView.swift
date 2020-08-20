//
//  SearchBarView.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func search(text: String)
    func searchBar(is hidden: Bool)
}

final class NavigationBarView: NibLoadingView, UISearchBarDelegate {
    
    // MARK: - Constants

    private struct Constants {
        static let animationDuration: TimeInterval = 0.5
    }

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var searchBarView: UIView!
    var delegate: HeaderViewDelegate?
    private var searchStr = ""
    var searchBarIsHidden: Bool = true {
        didSet {
            updateSearchBar()
            delegate?.searchBar(is: searchBarIsHidden)
        }
    }
    
    // MARK: - View life cycle

    override func awakeFromNib() {
        searchBar.delegate = self
        searchBarIsHidden = true
    }
    
    // MARK: - Private
    
    private func updateSearchBar() {
        searchBar.text = ""
        searchBarView.isHidden = searchBarIsHidden
        searchButton.alpha = searchBarIsHidden ? 1 : 0
        searchButton.isHidden = !searchBarIsHidden
        UIView.animate(withDuration: Constants.animationDuration) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonAction(_ sender: Any) {
        searchBarIsHidden = false
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        searchBarIsHidden = true
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        searchStr = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        delegate?.search(text: searchStr)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .white, textColor: .darkGray)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setTextFieldColor(color: .darkGray, textColor: .white)
    }
}
