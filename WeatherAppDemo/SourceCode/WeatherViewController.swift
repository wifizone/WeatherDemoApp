//
//  WeatherViewController.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import UIKit

protocol WeatherViewControllable: AnyObject {
    func setCityName(_ name: String)
    func update(temperature: String, updated: String)
    func alert(message: String)
    func showLoading(isShown: Bool)
}

final class WeatherViewController: UIViewController {

    private let presenter: WeatherPresenting

    private lazy var initialModel: WeatherViewModel = presenter.initialModel()

    private lazy var currentCityLabel: UILabel = {
        let label = UILabel().disabledMasks()
        label.text = initialModel.chosenCity
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel().disabledMasks()
        label.text = initialModel.temperature
        return label
    }()

    private lazy var updatedLabel: UILabel = {
        let label = UILabel().disabledMasks()
        label.text = initialModel.updated
        return label
    }()

    private lazy var citiesControl: UISegmentedControl = {
        let control = UISegmentedControl(items: initialModel.allCities).disabledMasks()
        control.selectedSegmentIndex = initialModel.chosenCityindex
        control.addTarget(self, action: #selector(segmentControl), for: .valueChanged)
        return control
    }()

    private let loadingVC = LoadingViewController()

    init(presenter: WeatherPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.didLoad()
    }

    private func setupView() {
        view.backgroundColor = .white
        [currentCityLabel, temperatureLabel, updatedLabel, citiesControl].forEach({ view.addSubview($0) })
        NSLayoutConstraint.activate([
            currentCityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            currentCityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: currentCityLabel.bottomAnchor, constant: 40),
            temperatureLabel.centerXAnchor.constraint(equalTo: currentCityLabel.centerXAnchor),

            updatedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            updatedLabel.centerXAnchor.constraint(equalTo: currentCityLabel.centerXAnchor),

            citiesControl.topAnchor.constraint(equalTo: updatedLabel.bottomAnchor, constant: 60),
            citiesControl.centerXAnchor.constraint(equalTo: currentCityLabel.centerXAnchor),
        ])
    }

    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        temperatureLabel.text = initialModel.temperature
        updatedLabel.text = initialModel.updated
        presenter.didChangeSelectedCity(index: segmentedControl.selectedSegmentIndex)
    }
}

extension WeatherViewController: WeatherViewControllable {
    func setCityName(_ name: String) {
        currentCityLabel.text = name
    }

    func update(temperature: String, updated: String) {
        temperatureLabel.text = temperature
        updatedLabel.text = updated
    }

    func alert(message: String) {
        showAlert(with: message)
    }

    func showLoading(isShown: Bool) {
        if isShown {
            add(loadingVC)
        } else {
            loadingVC.remove()
        }
    }
}
