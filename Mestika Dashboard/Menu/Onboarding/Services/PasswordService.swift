//
//  PasswordService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 28/11/20.
//

import Foundation
import SwiftyRSA

class PasswordService {
    
    private init() {}
    
    static let shared = PasswordService()
    
    /* GET VALIDATION PASSWORD */
    func getValidationPassword(
        password: String,
        completion: @escaping(Result<PasswordResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlPasswordValidation() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
    
        let body: [String: Any] = [
            "pwd": password
        ]
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            
            request.httpBody = jsonData
        } catch let error {
            print(error.localizedDescription)
            completion(Result.failure(ErrorResult.parser(string: "ERROR DECODING")))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 400) {
                    let passwordResponse = try? JSONDecoder().decode(PasswordResponse.self, from: data)
                    completion(.success(passwordResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    func encrypt(data: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: data, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
    }
}
