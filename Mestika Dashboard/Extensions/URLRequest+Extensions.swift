//
// Created by Prima Jatnika on 24/11/20.
//

import Foundation
import SwiftUI
import Firebase

extension URLRequest {
    
    init(_ url: URL) {
        self.init(url: url)
        self.timeoutInterval = 60
        self.setValue("*/*", forHTTPHeaderField: "accept")
        
        let preferences = UserDefaults.standard
        
        if let token = Messaging.messaging().fcmToken {
            if let indexEnd = token.index(of: ":") {
                let firebaseId = String(token[..<indexEnd])
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
                
//                self.setValue("78590B4C-2A37-4EE9-9858-A861A020011D", forHTTPHeaderField: "X-Device-ID")
                self.setValue("\(deviceId)", forHTTPHeaderField: "X-Device-ID")
                self.setValue(firebaseId, forHTTPHeaderField: "X-Firebase-ID")
                self.setValue(token, forHTTPHeaderField: "X-Firebase-Token")
                self.setValue("id", forHTTPHeaderField: "Accept-Language")
                self.setValue("46e8af0d-d289-49b8-8183-b0a7d9c7e78b", forHTTPHeaderField: "X-XSRF-TOKEN")
                self.setValue("XSRF-TOKEN=46e8af0d-d289-49b8-8183-b0a7d9c7e78b", forHTTPHeaderField: "cookie")
//                self.setValue("812939012309123", forHTTPHeaderField: "X-ENCRYPT-ID")

                let currentLevelKey = "X-XSRF-TOKEN"
                let xrsf = preferences.string(forKey: currentLevelKey)
                print(xrsf)
//                self.setValue("\(xrsf)", forHTTPHeaderField: "X-XSRF-TOKEN")
//                self.setValue("XSRF-TOKEN=\(xrsf)", forHTTPHeaderField: "cookie")
                
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
