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
}
