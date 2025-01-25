//
//  Coordinator.swift
//  Todoey
//
//  Created by Omar Assidi on 17/01/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var onComplete: (() -> Void)? { get set }
    func start()
}

extension Coordinator {
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    func remove(coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

//public enum Storyboard: String {
//    case main = "Main"
//
//    var instance: UIStoryboard {
//        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
//    }
//
//    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
//        let controllerIdInStoryboard = (viewControllerClass).storyboardID
//        guard let scene = instance.instantiateViewController(withIdentifier: controllerIdInStoryboard) as? T else {
//            fatalError("ViewController with identifier \(controllerIdInStoryboard), not found in \(self.rawValue) Storyboard.\nFile : \(#file) \nLine Number : \(#line) \nFunction : \(#function)")
//        }
//
//        return scene
//    }
//}
//
//extension UIViewController {
//
//    class var storyboardID: String {
//        return "\(self)"
//    }
//
//    static func instantiate() -> Self {
//        return Storyboard.main.viewController(viewControllerClass: self)
//    }
//}
