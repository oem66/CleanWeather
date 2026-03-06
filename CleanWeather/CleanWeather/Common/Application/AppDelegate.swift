//
//  AppDelegate.swift
//  CleanWeather
//
//  Created by Omer Rahmanovic on 27. 2. 2024..
//

import Foundation
import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        loadStores()
        setupSwiftyBeaver()
        setupTabBarAppearance()
        return true
    }
}

// MARK: - SwiftyBeaver private method
extension AppDelegate {
    private func setupSwiftyBeaver() {
#if DEBUG
        let console: ConsoleDestination = .init()
        log.addDestination(console)
#else
        log.removeAllDestinations()
#endif
    }
    
    func loadStores() {
        CoreDataManager.shared.loadStores()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        appearance.shadowColor = UIColor.white.withAlphaComponent(0.04)

        let selectedColor = UIColor.white
        let normalColor = UIColor.white.withAlphaComponent(0.52)

        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
