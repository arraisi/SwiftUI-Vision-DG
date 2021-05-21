//
// Created by Prima Jatnika on 24/11/20.
//

import Foundation
import SwiftUI
import Firebase

extension URLRequest {

    init(_ url: URL) {
        self.init(url: url)
        self.timeoutInterval = 30
        self.setValue("*/*", forHTTPHeaderField: "accept")
        
        if let token = Messaging.messaging().fcmToken {
            if let indexEnd = token.index(of: ":") {
                let firebaseId = String(token[..<indexEnd])
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
                
//                self.setValue("B13E3D5A-7918-4348-AD8F-7BDF65695F47", forHTTPHeaderField: "X-Device-ID")
                self.setValue("\(deviceId)", forHTTPHeaderField: "X-Device-ID")
                self.setValue(firebaseId, forHTTPHeaderField: "X-Firebase-ID")
                self.setValue(token, forHTTPHeaderField: "X-Firebase-Token")
                self.setValue("id", forHTTPHeaderField: "Accept-Language")
                
                print(deviceId)
                print(firebaseId)
                print(token)
            }
        } else {
            let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
            self.setValue(deviceId, forHTTPHeaderField: "X-Device-ID")
            self.setValue("id", forHTTPHeaderField: "Accept-Language")
        }
    }
}
