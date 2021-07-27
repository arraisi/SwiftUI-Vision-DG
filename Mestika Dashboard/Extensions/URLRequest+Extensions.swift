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
        
        let newDeviceId = "ios" +
            ":" + "\(UIDevice.current.identifierForVendor!.uuidString.replacingOccurrences(of: "-", with: ""))" +
            ":" + "\(UIDevice().type.rawValue)" +
            ":" + "\(UIDevice.current.model)" +
            ":" + "release-keys" +
            ":" + "user" +
            ":" + "retina" +
            ":" + "1626332354954"
        
        let encryptDeviceId = try! BlowfishEncode().encryptedWithKey(data: newDeviceId.data(.utf8), key: AppConstants().KEY_ENCRYPT_DEVICE_ID)
        
        if let token = Messaging.messaging().fcmToken {
            if let indexEnd = token.index(of: ":") {
                let firebaseId = String(token[..<indexEnd])
                let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
                
//                self.setValue("cazUvkRAYYg7eYezlfzfaZWSUw7WMj5qCvK7CnXZa1vclSPbGnmCaniHDLz9osFdCcfUQ9icGmdJeySfXhiOjU7s2DJausyDETW0dRbSt71fUvbq/5dKPu4BqhB/clUd", forHTTPHeaderField: "X-Device-ID")
                self.setValue(encryptDeviceId, forHTTPHeaderField: "X-Device-ID")
                self.setValue(firebaseId, forHTTPHeaderField: "X-Firebase-ID")
                self.setValue(token, forHTTPHeaderField: "X-Firebase-Token")
                self.setValue("id", forHTTPHeaderField: "Accept-Language")
                self.setValue("cf5f0cb5-5482-44e9-90e0-a59441d090a5", forHTTPHeaderField: "X-XSRF-TOKEN")
                self.setValue("XSRF-TOKEN=cf5f0cb5-5482-44e9-90e0-a59441d090a5", forHTTPHeaderField: "cookie")
                
                if let stringToken = defaults.string(forKey: defaultsKeys.keyToken) {
                    self.setValue("Bearer \(stringToken)", forHTTPHeaderField: "Authorization")
                }
                
//                if let stringXsrf = defaults.string(forKey: defaultsKeys.keyXsrf) {
//                    self.setValue(stringXsrf, forHTTPHeaderField: "X-XSRF-TOKEN")
//                    self.setValue("XSRF-TOKEN=\(stringXsrf)", forHTTPHeaderField: "cookie")
//                }
                
                if AppConstants().ENCRYPTED {
                    self.setValue("blowfish", forHTTPHeaderField: "X-ENCRYPT-ID")
                }
                
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
