//
//  Assembly.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import UIKit

final class Assembly {

    private lazy var weatherService = WeatherFetchingService()

    func createWeatherViewController() -> UIViewController {
        let presenter = WeatherPresenter(weatherService: weatherService)
        let vc = WeatherViewController(presenter: presenter)
        presenter.viewController = vc
        return vc
    }
}
