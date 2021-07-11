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
        
        let defaults = UserDefaults.standard
        let timestamp = NSDate().timeIntervalSince1970
        
        if let token = Messaging.messaging().fcmToken {
            if let indexEnd = token.index(of: ":") {
                let firebaseId = String(token[..<indexEnd])
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
                
//                self.setValue("872CBB01-E7B2-4F5C-B863-3A74D7AA136B", forHTTPHeaderField: "X-Device-ID")
                self.setValue("\(deviceId)", forHTTPHeaderField: "X-Device-ID")
                self.setValue(firebaseId, forHTTPHeaderField: "X-Firebase-ID")
                self.setValue(token, forHTTPHeaderField: "X-Firebase-Token")
                self.setValue("id", forHTTPHeaderField: "Accept-Language")
                self.setValue("cf5f0cb5-5482-44e9-90e0-a59441d090a5", forHTTPHeaderField: "X-XSRF-TOKEN")
                self.setValue("XSRF-TOKEN=cf5f0cb5-5482-44e9-90e0-a59441d090a5", forHTTPHeaderField: "cookie")
//                self.setValue("Bearer eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAKtWyiwuVrJSSk1Mz0lV0lHKTCxRsjI0MzK1MDIwsDTQUUqtKIAIWBqYmYAESotTi_ISc1OBmgygQNcs0SBZ19gwxVQXzE0Nzol3LMjOC0p2N4ko8c62qPRzNjTXBRpflZ8H0picn6RUCwC6S0EFewAAAA._nSlCn2c-H2OdjuAx5LnenRplIl8cBgtTRJsY1rBRVA", forHTTPHeaderField: "Authorization")
                
                if let stringToken = defaults.string(forKey: defaultsKeys.keyToken) {
                    self.setValue("Bearer \(stringToken)", forHTTPHeaderField: "Authorization")
                }
                
//                if let stringXsrf = defaults.string(forKey: defaultsKeys.keyXsrf) {
//                    self.setValue(stringXsrf, forHTTPHeaderField: "X-XSRF-TOKEN")
//                    self.setValue("XSRF-TOKEN=\(stringXsrf)", forHTTPHeaderField: "cookie")
//                }
                
//                self.setValue(String(timestamp), forHTTPHeaderField: "X-ENCRYPT-ID")
                
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
