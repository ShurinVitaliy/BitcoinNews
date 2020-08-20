//
//  AppDelegate.swift
//  BitcoinNews
//
//  Created by VitaliyShurin on 19.08.2020.
//  Copyright © 2020 VitaliyShurin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var fisrtCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        MainCoordinator.shared.window = self.window
        MainCoordinator.shared.coordinate(to: MainCoordinator.Target.main)
        return true
    }
}
