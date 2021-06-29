//
//  StompClientModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/05/21.
//

import Combine
import Foundation
import SwiftStomp
import SwiftUI
import SwiftyRSA

class WebSocket: NSObject, SwiftStompDelegate {
    
    // Device ID
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Connected")
        
        swiftStomp.subscribe(to: "/open/changes/\(deviceId!)")
        swiftStomp.subscribe(to: "/close/changes/\(deviceId!)")
        swiftStomp.subscribe(to: "/websocket-notification")
        
        NotificationCenter.default.post(name: NSNotification.Name("CheckWebsocket"), object: nil, userInfo: nil)
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Disconnected")
        
        swiftStomp.unsubscribe(from: "/open/changes/\(deviceId!)")
        swiftStomp.unsubscribe(from: "/close/changes/\(deviceId!)")
        swiftStomp.unsubscribe(from: "/websocket-notification")
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {
        
        print(destination)
        
        if (destination == "/websocket-notification") {
            print("Notif")
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = "Jadwal Video Call"
                    content.subtitle = "09.00 - 10.00"
                    content.sound = UNNotificationSound.default

                    // show this notification five seconds from now
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                    // choose a random identifier
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        } else {
            print("Vcall")
            if let message = message as? String {
                print("Message with id `\(messageId)` received at destination `\(destination)`:\n\(message)")
                let data = decrypt(message.trimmingCharacters(in: .whitespacesAndNewlines), AppConstants().PUBLIC_KEY_RSA)
                
                print(data)
                
                let jsonData = Data(data?.utf8 ?? "".utf8)

                let decoder = JSONDecoder()

                do {
                    let data = try decoder.decode(ReceivingMessage.self, from: jsonData)
                    print(data.roomId)
                    
                    if (data.notificationType == "START") {
                        
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                let content = UNMutableNotificationContent()
                                content.title = "Incoming Call"
                                content.subtitle = "Bank Mestika Calling ..."
                                content.sound = UNNotificationSound.default

                                // show this notification five seconds from now
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                                // choose a random identifier
                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                // add our notification request
                                UNUserNotificationCenter.current().add(request)
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        
                        let dataRoom: [String: Any] = ["room_id": data.roomId]
                        NotificationCenter.default.post(name: NSNotification.Name("Detail"), object: nil, userInfo: dataRoom)
                    }
                    
                    if (data.notificationType == "END") {
                        NotificationCenter.default.post(name: NSNotification.Name("JitsiEnd"), object: nil, userInfo: nil)
                    }

                } catch {
                    print(error.localizedDescription)
                }
                
            } else if let message = message as? Data{
                print("Data message with id `\(messageId)` and binary length `\(message.count)` received at destination `\(destination)`")
            }
        }
        
    }
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("Error")
        print(type)
        
        NotificationCenter.default.post(name: NSNotification.Name("ErrorWebsocket"), object: nil, userInfo: nil)
    }
    
    func onSocketEvent(eventName: String, description: String) {
        
    }
    
    func decrypt(_ encryptData: String, _ privateKey: String) -> String? {
        print("ini encryptnya")
        print("Data" + encryptData)
        guard let baseDecodeData = Data(base64Encoded: encryptData) else {
            
            print("Kosong")
            return nil
        }
        let decryptedInfo = RSAUtils.decryptWithRSAPublicKey(baseDecodeData, pubkeyBase64: privateKey, keychainTag: "")
          if ( decryptedInfo != nil ) {
              let result = String(data: decryptedInfo!, encoding: .utf8)
              return result
          } else {
              print("Error while decrypting")
              return nil
          }
    }
}

final class StompClientModel: ObservableObject {
    
    func connect() { // 2
        
        let url = URL(string: AppConstants().WEBSOCKET_URL)!
        
        let stomp = SwiftStomp(host: url)
        stomp.delegate = WebSocket()
        
        stomp.autoReconnect = true
        stomp.connect()
    }
}

struct ReceivingMessage: Codable {
    var roomId: String
    var deviceId: String
    var notificationType: String
}
