//
//  UIView+Extensions.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import UIKit

extension UIView {

    func disabledMasks() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
