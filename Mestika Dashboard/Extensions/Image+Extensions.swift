//
//  Image+Extensions.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/12/20.
//

import Foundation
import Combine
import SwiftUI

extension Image {
    func toBase64() -> String? {
        guard let imageData = self.asUIImage().pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
