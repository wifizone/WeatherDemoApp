//
//  AppDelegate.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var assembly = Assembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootViewController()
        return true
    }

    private func setupRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = assembly.createWeatherViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

