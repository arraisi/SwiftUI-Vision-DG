//
//  UINavigationController+Extensions.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 10/01/21.
//

import UIKit

extension UINavigationController {
    func removeStacks<T>(ofType: T.Type) {
        self.viewControllers.removeAll(where: { (vc) -> Bool in
            if let _ = vc as? T {
                return false
            } else {
                return true
            }
        })
    }
}
