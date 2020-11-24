//
// Created by Prima Jatnika on 24/11/20.
//

import Foundation
import SwiftUI

extension URLRequest {

    init(_ url: URL) {
        self.init(url: url)
        self.setValue("*/*", forHTTPHeaderField: "accept")
        self.setValue(UIDevice.current.identifierForVendor?.uuidString, forHTTPHeaderField: "X-Device-ID")
        self.setValue("1", forHTTPHeaderField: "X-Firebase-ID")
    }
}