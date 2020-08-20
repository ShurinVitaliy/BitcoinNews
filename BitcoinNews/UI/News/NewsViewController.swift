//
//  NewsPageViewController.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HeaderViewDelegate {
    
    // MARK: - Constants

    private struct Constants {
        static let standartAnimationDuration: Double = 0.4
        static let spacingBetweenCells: CGFloat = 40
        static let cellCornerRadius: CGFloat = 10
        static let numberOfRowsInSection: Int = 1
        static let loadingTableViewCellName = "loadingTableViewCellName"
        static let newsTableViewCellName = "NewsTableViewCell"
        static let searchMessage = "Sorry, we couldn't find "
        static let maxDaysAgo = 7
    }
    
    // MARK: - Properties

    @IBOutlet private weak var navigationBarView: NavigationBarView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var infoLabel: UILabel!
    private let refreshControl = UIRefreshControl()
    private var coordinator: Coordinator = MainCoordinator.shared
    private var cellModels: [Any] = []
    private var newsData: [PieceOfNews] = []
    private var loading: Bool = false
    private var showLoadingIndicator: Bool = true
    private var fromDate: Date = Date()
    private var toDate: Date = Date()
    private var sortedBy: SortedBy = .publishedAt
    private var countOfDayAgo: Int = 0
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadCellModels()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func setupView() {
        tableView.register(UINib(nibName: Constants.newsTableViewCellName, bundle: nil), forCellReuseIdentifier: Constants.newsTableViewCellName)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: Constants.loadingTableViewCellName)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        refreshControl.isHidden = true
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        navigationBarView.delegate = self
    }
        
    private func reloadCellModels(completion: (() -> Void)? = nil) {
        guard !loading else {
            return
        }
        countOfDayAgo = 0
        fromDate = Date()
        toDate = Date()
        newsData = []
        cellModels = []
        showLoadingIndicator = true
        loadData(completion: completion)
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        guard !loading else {
            return
        }
        loading = true
        preloadingState()
        APIManager.shared.getMyPathModel(fromDate: fromDate, toDate: toDate, sortedBy: sortedBy) { [weak self] result in
            switch result {
            case .success(let resultData):
                guard let items = resultData.articles, let self = self else {
                    return
                }
                guard !items.isEmpty else {
                    self.loading = false
                    self.fromDate = self.fromDate.yesterday
                    self.loadData(completion: completion)
                    return
                }
                self.showLoadingIndicator = self.countOfDayAgo < Constants.maxDaysAgo
                self.newsData.append(contentsOf: items)
                self.builCellModels(completion: completion)
            case .failure(let error):
                if !error.localizedDescription.isEmpty {
                    self?.coordinator.coordinate(to: MainCoordinator.Target.error(error.localizedDescription))
                }
            }
            self?.loading = false
        }
    }
    
    private func builCellModels(completion: (() -> Void)? = nil) {
        cellModels = []
        cellModels.append(contentsOf: newsData)
        if showLoadingIndicator {
            cellModels.append(LoadingModel())
        }
        refreshControl.endRefreshing()
        tableView.reloadData()
        guard let completion = completion else {
            return
        }
        completion()
    }
    
    private func preloadingState() {
        if cellModels.isEmpty || newsData.isEmpty {
            if showLoadingIndicator {
                let exist = cellModels.contains { (model) -> Bool in
                    return model is LoadingModel
                }
                if !exist {
                    cellModels.append(LoadingModel())
                }
            }
            tableView.reloadData()
        }
    }
    
    private func searchAction(with text: String) {
        func updateInfoLabel(hide: Bool) {
            infoLabel.text = Constants.searchMessage + "'\(text)'"
            infoLabel.alpha = hide ? 0 : 1
            infoLabel.isHidden = hide
            UIView.animate(withDuration: Constants.standartAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
        guard !text.isEmpty else {
            updateInfoLabel(hide: true)
            builCellModels()
            return
        }
        cellModels = newsData.filter { ($0.title?.lowercased().contains(text.lowercased()) ?? false) }
        updateInfoLabel(hide: !cellModels.isEmpty)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func refresh(_ sender: AnyObject) {
        reloadCellModels()
    }
    
    @IBAction func showMoreButtonAction() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func showMore(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell,
            tableView.visibleCells.contains(cell) else {
                return
        }
        tableView.beginUpdates()
        cell.showMoreButton.isHidden = true
        cell.subtitleLabel.numberOfLines = 0
        tableView.endUpdates()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        guard index < cellModels.count else {
            return UITableViewCell()
        }
        let model = cellModels[index]
        var cell: UITableViewCell
        switch model {
        case let newsModel as PieceOfNews:
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: Constants.newsTableViewCellName,
                                                                  for: indexPath) as? NewsTableViewCell else {
                return UITableViewCell()
            }
            newsCell.setup(with: newsModel)
            newsCell.showMoreAction = { [weak self] in
                self?.showMore(at: indexPath)
            }
            cell = newsCell
        case _ as LoadingModel:
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingTableViewCellName,
                                                                  for: indexPath) as? LoadingCell else {
                return UITableViewCell()
            }
            loadingCell.color = .white
            loadingCell.selectionStyle = .none
            return loadingCell
        default:
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.clipsToBounds = true
        cell.layer.cornerRadius = Constants.cellCornerRadius
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NewsTableViewCell else { return }
        cell.newsImageView.kf.cancelDownloadTask()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.section
        guard let model = cellModels[index] as? PieceOfNews, let url = model.url else { return }
        coordinator.coordinate(to: MainCoordinator.Target.webPage(url))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : Constants.spacingBetweenCells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == cellModels.count - 1 && showLoadingIndicator {
            countOfDayAgo += 1
            fromDate = fromDate.someDaysAgoDate(countOfDayAgo)
            toDate = toDate.someDaysAgoDate(countOfDayAgo)
            loadData()
        }
    }
    
    // MARK: - HeaderViewDelegate
    
    func search(text: String) {
        searchAction(with: text)
    }
    
    func searchBar(is hidden: Bool) {
        if hidden {
            searchAction(with: "")
        }
        UIView.animate(withDuration: Constants.standartAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
