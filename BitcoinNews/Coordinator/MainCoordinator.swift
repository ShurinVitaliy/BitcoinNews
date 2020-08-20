//
//  MainCoordinator.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//
import MBProgressHUD
import UIKit
import SafariServices

protocol CoordinatorTarget {}

protocol Coordinator: class {
    @discardableResult func coordinate(to: CoordinatorTarget) -> Bool
    var window: UIWindow? { get set }
}

final class MainCoordinator: Coordinator {
    
    // MARK: - Inner types
    
    private struct Constants {
        static let errorDuration = 3.0
    }
    
    enum Target: CoordinatorTarget {
        case main
        case webPage(_ url: String)
        case error(_ text: String = "Something went wrong.")
    }
    
    // MARK: - Properties
    
    static let shared = MainCoordinator()
    
    var window: UIWindow? {
        didSet {
            childCoordinators = createChildCoordinators(for: window)
        }
    }
    
    private var childCoordinators: [Coordinator] = []
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Coordinator API
    
    @discardableResult func coordinate(to target: CoordinatorTarget) -> Bool {
        
        for coordinator in childCoordinators {
            if coordinator.coordinate(to: target) { return true }
        }
        
        guard let target = target as? Target else { return false }
        
        switch target {
        case .main:
            self.window?.rootViewController = NewsViewController()
        case .webPage(let url):
            guard let url = URL(string: url) else {
                return false
            }
            let safariViewController = SFSafariViewController(url: url)
            window?.rootViewController?.present(safariViewController, animated: true)
        case .error(let message):
            guard let window = window else { return false }
            let hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud.isUserInteractionEnabled = false
            hud.mode = .text
            hud.label.text = message
            hud.hideError(message: message, afterDelay: Constants.errorDuration)
        }
        return true
    }
    
    // MARK: - Private
    
    private func createChildCoordinators(for window: UIWindow?) -> [Coordinator] {
        return []
    }
}
