//
//  KartuKuService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/02/21.
//

import Foundation
import Combine
import SwiftyRSA

class KartuKuService {
    private init() {}
    static let shared = KartuKuService()
    
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
    
    // MARK: - GET LIST KARTKU KU
    func getListKartuKu(completion: @escaping(Result<KartuKuResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetListKartuKu() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("response: \(String(describing: response))")
            
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let kartuKuResponse = try? JSONDecoder().decode(KartuKuResponse.self, from: data!)
                    if let kartuKu = kartuKuResponse {
                        completion(.success(kartuKu))
                    }
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - POST ACTIVATE KARTKU KU
    func postActivateKartKu(data: ActivateKartuKuModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": data.cardNo,
            "cvv": data.cvv,
            "pin": encryptPassword(password: data.newPin),
            "pinTrx": encryptPassword(password: data.pinTrx),
        ]
        
        guard let url = URL.urlActivateKartuKu() else {
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
            print(jsonString)
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
                    let dataResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(dataResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST BROKEN KARTKU KU
    func postBrokenKartKu(data: BrokenKartuKuModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": data.cardNo,
            "pin": encryptPassword(password: data.pin)
        ]
        
        guard let url = URL.urlBrokenKartuKu() else {
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
            print(jsonString)
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
                    let dataResponse = try? JSONDecoder().decode(Status.self, from: data)
                    completion(.success(dataResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
