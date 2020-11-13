//
//  OffsetKey.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/11/20.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?,
                       nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}
