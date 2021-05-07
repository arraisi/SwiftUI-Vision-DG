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

class WebSocket: NSObject, SwiftStompDelegate {
    
    // Device ID
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
        print("Connected")
        
        swiftStomp.subscribe(to: "/open/changes/\(deviceId!)")
        swiftStomp.subscribe(to: "/close/changes/\(deviceId!)")
        
        NotificationCenter.default.post(name: NSNotification.Name("CheckWebsocket"), object: nil, userInfo: nil)
    }
    
    func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
        print("Disconnected")
        
        swiftStomp.unsubscribe(from: "/open/changes/\(deviceId!)")
        swiftStomp.unsubscribe(from: "/close/changes/\(deviceId!)")
    }
    
    func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers: [String : String]) {

        if let message = message as? String{
            print("Message with id `\(messageId)` received at destination `\(destination)`:\n\(message)")
            
            let jsonData = Data(message.utf8)

            let decoder = JSONDecoder()

            do {
                let data = try decoder.decode(ReceivingMessage.self, from: jsonData)
                print(data.roomId)
                
                if (data.notificationType == "START") {
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
    
    func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
        
    }
    
    func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
        print("Error")
        print(type)
        
        NotificationCenter.default.post(name: NSNotification.Name("ErrorWebsocket"), object: nil, userInfo: nil)
    }
    
    func onSocketEvent(eventName: String, description: String) {
        
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
