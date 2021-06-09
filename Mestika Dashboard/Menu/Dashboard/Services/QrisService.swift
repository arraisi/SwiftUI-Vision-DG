//
//  QrisServices.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/04/21.
//

import Foundation
import Combine
import SwiftyRSA

class QrisService {
    
    private init() {}
    static let shared = QrisService()
    
    func encryptPassword(password: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: password, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
        //        self.registerData.password = base64String
    }
    
    // MARK: - POST PARSE QRIS
    func parseQris(qrisData: QrisModel,
                      completion: @escaping(Result<ParseQrisResponseModel, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "content": qrisData.content,
        ]
        
        guard let url = URL.urlParseQris() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString as Any)
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
                
                if (httpResponse.statusCode == 200) {
                    let transferResponse = try? JSONDecoder().decode(ParseQrisResponseModel.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST PAY QRIS
    func payQris(qrisData: QrisModel,
                      completion: @escaping(Result<PayQrisResponseModel, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "PAN": qrisData.pan,
            "fromAccountName": qrisData.fromAccountName,
            "content": qrisData.content,
            "fromAccount": qrisData.fromAccount,
            "pinTrx": encryptPassword(password: qrisData.pinTrx),
            "transactionAmount": qrisData.transactionAmount,
            "transactionFee": qrisData.transactionFee
        ]
        
        guard let url = URL.urlPayQris() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString as Any)
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
                
                if (httpResponse.statusCode == 200) {
                    let transferResponse = try? JSONDecoder().decode(PayQrisResponseModel.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 406) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST CHECK STATUS QRIS
    func checkStatusQris(qrisData: QrisModel,
                      completion: @escaping(Result<PayQrisResponseModel, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "PAN": qrisData.pan,
            "fromAccountName": qrisData.fromAccountName,
            "content": qrisData.content,
            "fromAccount": qrisData.fromAccount,
            "pinTrx": encryptPassword(password: qrisData.pinTrx),
            "transactionAmount": qrisData.transactionAmount,
            "transactionFee": qrisData.transactionFee,
            "reffNo": qrisData.reffNumber
        ]
        
        guard let url = URL.urlCheckStatusQris() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString as Any)
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
                
                if (httpResponse.statusCode == 200) {
                    let transferResponse = try? JSONDecoder().decode(PayQrisResponseModel.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
