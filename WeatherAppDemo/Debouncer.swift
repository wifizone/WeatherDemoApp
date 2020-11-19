//
//  Debouncer.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import Foundation

final class Debouncer {

    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?

    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    @objc private func fireNow() {
        self.callback()
    }
}
