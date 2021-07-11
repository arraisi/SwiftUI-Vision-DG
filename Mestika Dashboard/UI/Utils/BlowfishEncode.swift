//
//  BlowfishEncode.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/07/21.
//

import Foundation
import CryptoSwift

class BlowfishEncode {
    
    public func encryptedReturnData(data: Data) -> Data? {
        
        let encrypted = try! Blowfish(key: AppConstants().PRIVATE_KEY_RSA, iv: "drowssapdrowssap", padding: .pkcs7).encrypt(data.bytes)
        
        let result = Data(encrypted)
        
        print("ENCRYPTED RESULT")
        print(String(data: result, encoding: .utf8))
        
        return Data(encrypted)
    }
    
    public func encryptedReturnString(data: Data) -> String? {
        
        let encrypted = try! Blowfish(key: AppConstants().PRIVATE_KEY_RSA, iv: "drowssapdrowssap", padding: .pkcs7).encrypt(data.bytes)
        
        let result = Data(encrypted)
        
        print("ENCRYPTED RESULT")
        print(String(data: result, encoding: .utf8))
        
        return String(data: result, encoding: .utf8)
    }
    
    public func decrypted(data: Data) -> String? {
        
        let decrypted = try! Blowfish(key: AppConstants().PRIVATE_KEY_RSA, iv: "drowssapdrowssap", padding: .pkcs7).decrypt(data.bytes)
        
        let result = Data(decrypted)
        
        print("DECRYPTED RESULT")
        print(String(data: result, encoding: .utf8))
        
        return String(data: result, encoding: .utf8)

    }
    
}
