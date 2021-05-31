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
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
            
            let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            return false
        }
    }
}
