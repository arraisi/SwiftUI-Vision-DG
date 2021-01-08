//
//  View+Extensions.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 07/01/21.
//

import SwiftUI
import UIKit

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }
