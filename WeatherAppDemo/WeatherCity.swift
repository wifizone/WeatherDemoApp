//
//  WeatherCity.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import Foundation

enum WeatherCity: Int, CaseIterable {
    case london = 0
    case helsinki

    func name() -> String {
        switch self {
        case .helsinki:
            return "Helsinki"
        case .london:
            return "London"
        }
    }
}
