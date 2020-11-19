//
//  WeatherPresenter.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import Foundation

protocol WeatherPresenting: AnyObject {
    func initialModel() -> WeatherViewModel
    func didLoad()
    func didChangeSelectedCity(index: Int)
}

final class WeatherPresenter {

    private struct Constants {
        static let temperatureText = "Temperature: "
        static let celsiusSign = "°C"
        static let updatedText = "Updated: "
        static let secondsInMinute: TimeInterval = 10
    }

    weak var viewController: WeatherViewControllable?
    private let weatherService: WeatherFetching
    private lazy var debouncedRequest = Debouncer(delay: 1, callback: { [weak self] in
        self?.requestWeather()
    })

    private var currentCity: WeatherCity = .helsinki
    private let allCities = WeatherCity.allCases.map({ $0.name() })
    private var isPossibleToRequest = true

    init(weatherService: WeatherFetching) {
        self.weatherService = weatherService
    }
}

extension WeatherPresenter: WeatherPresenting {

    func initialModel() -> WeatherViewModel {
        return WeatherViewModel(chosenCity: currentCity.name(),
                                chosenCityindex: currentCity.rawValue,
                                temperature: Constants.temperatureText,
                                updated: Constants.updatedText,
                                allCities: allCities)
    }

    func didLoad() {
        self.requestWeather(loadingRequired: true)
        Timer.scheduledTimer(withTimeInterval: Constants.secondsInMinute, repeats: true) { _ in
            self.debouncedRequest.call()
        }
    }

    func didChangeSelectedCity(index: Int) {
        guard let currentCity = WeatherCity(rawValue: index) else {
            assertionFailure("City should be in WeatherCity enum")
            return
        }
        self.currentCity = currentCity
        viewController?.showLoading(isShown: true)
        debouncedRequest.call()
        viewController?.setCityName(allCities[index])
    }

    private func requestWeather(loadingRequired: Bool = false) {
        if loadingRequired {
            viewController?.showLoading(isShown: true)
        }
        weatherService.requestTemperature(city: currentCity) { [unowned self] result in
            DispatchQueue.main.async {
                viewController?.showLoading(isShown: false)
                self.process(result: result)
            }
        }
    }

    private func process(result: Result<WeatherResponseModel, WeatherError>) {
        switch result {
        case let .success(model):
            processModel(model: model)
        case .failure:
            viewController?.alert(message: "Error loading weather")
        }
    }

    private func processModel(model: WeatherResponseModel) {
        if let currentTemperature = getTemperatureText(from: model),
           let lastUpdatedTime = getTimeUpdatedText() {
            viewController?.update(temperature: currentTemperature,
                                   updated: lastUpdatedTime)
        }
    }

    // MARK: - Parsing

    private func getTemperatureText(from model: WeatherResponseModel) -> String? {
        guard let currentTemperatureDouble = model.consolidatedWeather.first?.theTemp else {
            return nil
        }
        return Constants.temperatureText + String(Int(round(currentTemperatureDouble))) + Constants.celsiusSign
    }

    private func getTimeUpdatedText() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return Constants.updatedText + formatter.string(from: Date())
    }
}
