//
//  UIViewController+Extensions.swift
//  WeatherAppDemo
//
//  Created by Антон Полуянов on 19.11.2020.
//

import UIKit

extension UIViewController {
    func showAlert(with alert: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(alertAction)
        if presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        }
    }
}
