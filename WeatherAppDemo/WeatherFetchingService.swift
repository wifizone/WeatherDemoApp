//
//  WeatherFetchingService.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import Foundation

enum WeatherError: Error {
    case server
    case parsing
    case incorrectRequest
}

protocol WeatherFetching: AnyObject {

    func requestTemperature(city: WeatherCity, completion: @escaping (Result<WeatherResponseModel, WeatherError>) -> Void)
}

final class WeatherFetchingService: WeatherFetching {

    private let session = URLSession.shared
    private var currentTask: URLSessionDataTask?

    func requestTemperature(city: WeatherCity, completion: @escaping (Result<WeatherResponseModel, WeatherError>) -> Void) {
        currentTask?.cancel()
        currentTask = nil

        guard let url = city.url() else {
            completion(.failure(.incorrectRequest))
            return
        }

        currentTask = session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            defer {
                self?.currentTask = nil
            }
            guard error == nil,
                  let responseCode = response as? HTTPURLResponse,
                  responseCode.statusCode == 200,
                  let data = data else {
                completion(.failure(.server))
                return
            }
            guard let weather = try? JSONDecoder().decode(WeatherResponseModel.self, from: data) else {
                completion(.failure(.parsing))
                return
            }

            completion(.success(weather))
        })

        currentTask?.resume()
    }
}

private extension WeatherCity {
    func url() -> URL? {
        switch self {
        case .helsinki:
            return URL(string: "https://www.metaweather.com/api/location/565346/")
        case .london:
            return URL(string: "https://www.metaweather.com/api/location/44418/")
        }
    }
}
