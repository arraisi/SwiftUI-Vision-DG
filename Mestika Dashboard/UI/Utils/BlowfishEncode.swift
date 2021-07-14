//
//  BlowfishEncode.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/07/21.
//

import Foundation
import Crypto
import SwiftyRSA

class BlowfishEncode {
    
    public func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func encryptKeyWithRSA(data: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: data, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
    }
    
    func decryptKeyFromResponse(data: Data) -> Data {
        print(String(data: data, encoding: .utf8))
        guard let dataDecrypt = Data(base64Encoded: String(data: data, encoding: .utf8)!) else { return data }
        
        guard let resultDecript = try! RSAUtils.decryptWithRSAPublicKey(encryptedData: dataDecrypt, pubkeyBase64: AppConstants().PUBLIC_KEY_RSA, tagName: "PUBIC") else { return data }
        
        return resultDecript
    }
    
    public func encrypted(data: Data) -> Data? {
        
        let key = randomString(length: 20)
        let encryptedKeyRSA = encryptKeyWithRSA(data: key)
        let iv = try! "blowfish".data(.ascii)
        
        
        if AppConstants().ENCRYPTED {
            let dataStr = String(data: data, encoding: .utf8)
            
            let encrypt = try! dataStr?.process(.blowfish(.encrypt, key: key, iv: iv, mode: .ecb, padding: .pkcs7))
            
            print(encrypt)
            
            let resultEncrypt = "{\"data\":\"" + encryptedKeyRSA + "-" + encrypt! + "\"}"
            
            print(resultEncrypt)
            
            return try! resultEncrypt.data(.utf8)
        }
        
        return data
        
    }
    
    public func decrypted(data: Data) -> Data? {
        
        if AppConstants().ENCRYPTED {
            
            let encryptResponse = try? JSONDecoder().decode(DecryptResponse.self, from: data)
            
            let dataStr = encryptResponse!.data
            let splitString = dataStr.components(separatedBy: "-")
            let key = decryptKeyFromResponse(data: splitString[0].data(using: .utf8)!)
            let iv = try! "blowfish".data(.ascii)
            
            
            print("KEY FROM RESPONSE")
            print(splitString[0])
            
            print("MESSAGE FROM RESPONSE")
            print(splitString[1])
            
            print("KEY DECRYPTEN RSA")
            print(String(data: key, encoding: .utf8) as Any)
            
            let decrypted = try! splitString[1].process(.blowfish(.decrypt, key: key, iv: iv, mode: .ecb, padding: .pkcs7))

            print(decrypted)
            
            return try! decrypted.data(.utf8)
            
        }
        
        return data
        
    }
    
}
