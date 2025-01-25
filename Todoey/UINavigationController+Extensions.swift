//
//  UINavigationController+Extensions.swift
//  Todoey
//
//  Created by Omar Assidi on 21/01/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit

extension UINavigationController {
    func decorateNavigationBarWith(appearance: UINavigationBarAppearance, tint: UIColor, isTranslucent: Bool, prefersLargeTitles: Bool) {
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        if #available(iOS 15.0, *) {
            self.navigationBar.compactScrollEdgeAppearance = appearance
        }
        self.navigationBar.isTranslucent = isTranslucent
        self.navigationBar.prefersLargeTitles = prefersLargeTitles
        self.navigationBar.tintColor = tint
    }
}
