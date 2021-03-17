//
//  SavingAccountServices.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation
import Combine
import SwiftyRSA

class SavingAccountServices {
    
    private init() {}
    
    static let shared = SavingAccountServices()
    
    // MARK: - GET LIST LAST PRODUCTS
    func getProducts(completion: @escaping(Result<ProductsSavingAccountModel, ErrorResult>) -> Void) {
        
        // MARK: URL
        guard let url = URL.urlGetProductsSavingAccount() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET PRODUCTS SAVING ACCOUNT SERVICE RESULT : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let products = try? JSONDecoder().decode(ProductsSavingAccountModel.self, from: data)
                    
                    if let _response = products {
                        completion(.success(_response))
                    }
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 405) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - GET PRODUCTS DETAILS
    func getProductDetails(planCode: String, completion: @escaping(Result<ProductDetailSavingAccountModel, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "planCode" : planCode
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlGetProductDetail() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET PRODUCT DETAILS SAVING ACCOUNT SERVICE RESULT : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let productDetails = try? JSONDecoder().decode(ProductDetailSavingAccountModel.self, from: data)
                    
                    guard let _response = productDetails else {
                       return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                    }
                    
                    completion(.success(_response))
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 405) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - GET LIST LAST ACCOUNT
    func getAccounts(completion: @escaping(Result<SavingAccountModel, ErrorResult>) -> Void) {
        
        // MARK: URL
        guard let url = URL.urlGetAccountsByCif() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET ACCOUNTS SERVICE RESULT : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let accounts = try? JSONDecoder().decode(SavingAccountModel.self, from: data)
                    
                    if let _response = accounts {
                        completion(.success(_response))
                    }
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 405) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - SAVE SAVING ACCOUNT
    func saveSavingAccount(kodePlan: String, deposit: String, pinTrx: String, completion: @escaping(Result<NewSavingAccountResponseModel, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "kodePlan": kodePlan,
            "deposit": deposit,
            "pinTrx": encryptPassword(password: pinTrx)
        ]
        
        print("body save saving account => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlSaveSavingAccount() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nSAVE SAVING ACCOUNT SERVICE RESULT : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let savingAccount = try? JSONDecoder().decode(NewSavingAccountResponseModel.self, from: data)
                    
                    guard let _response = savingAccount else {
                       return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                    }
                    
                    completion(.success(_response))
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 405) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
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
}
