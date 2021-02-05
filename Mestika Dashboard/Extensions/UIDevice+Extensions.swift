//
//  UIDevice+Extensions.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/02/21.
//

import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            // Fallback on earlier versions
            return false
        }
    }
}
