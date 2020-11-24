//
//  UIApplication.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/11/20.
//

import SwiftUI
import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
