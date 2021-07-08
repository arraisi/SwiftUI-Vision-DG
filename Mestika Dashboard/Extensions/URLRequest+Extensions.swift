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
                
//                self.setValue("D9FD4DAC-E830-4F02-AD23-DE96987F4D3E", forHTTPHeaderField: "X-Device-ID")
                self.setValue("\(deviceId)", forHTTPHeaderField: "X-Device-ID")
                self.setValue(firebaseId, forHTTPHeaderField: "X-Firebase-ID")
                self.setValue(token, forHTTPHeaderField: "X-Firebase-Token")
                self.setValue("id", forHTTPHeaderField: "Accept-Language")
//                self.setValue("812939012309123", forHTTPHeaderField: "X-ENCRYPT-ID")

                let currentLevelKey = "X-XSRF-TOKEN"
                let authToken = "AuthorizationToken"
                let xrsf = preferences.string(forKey: currentLevelKey)
                let auth = preferences.string(forKey: authToken)
                print("XRSF NYA")
                print(xrsf)
                self.setValue(xrsf?.trimmingCharacters(in: .whitespacesAndNewlines), forHTTPHeaderField: "X-XSRF-TOKEN")
                self.setValue("XSRF-TOKEN=\(xrsf?.trimmingCharacters(in: .whitespacesAndNewlines))", forHTTPHeaderField: "cookie")
                self.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
                
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
