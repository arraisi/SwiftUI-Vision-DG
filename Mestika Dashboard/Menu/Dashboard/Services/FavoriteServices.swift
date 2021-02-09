//
//  FavoriteServices.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/02/21.
//

import Foundation

class FavoriteServices {
    
    private init() {}
    
    static let shared = FavoriteServices()
    
    // MARK: - GET LIST FAVORITE
    func getList(cardNo: String, sourceNumber: String, completion: @escaping(Result<[FavoriteModelElement], ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "cardNo" : "5058200000000758",
            "sourceNumber" : "87000000126"
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlGetListFavorite() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET LIST FAVORITE SERVICE RESULST : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let favoriteListResponse = try? JSONDecoder().decode([FavoriteModelElement].self, from: data)
                    print("Favorites Count \(String(describing: favoriteListResponse?.count))\n\n")
                    
                    if let _response = favoriteListResponse {
                        completion(.success(_response))
                    }
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - REMOVE FAVORITE
    func update(data: FavoriteModelElement, name: String, completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "id" : data.id,
            "cardNo": data.cardNo,
            "sourceNumber": data.sourceNumber,
            "name": name
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlUpdateFavorite() else {
            return completion(Result.failure(ErrorResult.network(string: "NETWORK ERROR")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("RESPONSE SERVICE UPDATE FAVORITE : CODE \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 200) {
                    completion(.success(httpResponse.statusCode))
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - REMOVE FAVORITE
    func remove(data: FavoriteModelElement, completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "id" : data.id,
            "cardNo": data.cardNo,
            "sourceNumber": data.sourceNumber
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlRemoveFavorite() else {
            return completion(Result.failure(ErrorResult.network(string: "NETWORK ERROR")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("RESPONSE SERVICE REMOVE FAVORITE : CODE \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 200) {
                    completion(.success(httpResponse.statusCode))
                    
                } else {
                    // if we're still here it means there was a problem
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
            
        }.resume()
    }
    
    // MARK: - SAVE FAVORITE
    func save(requestData: FavoriteModelElement, completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "bankAccountNumber" : requestData.bankAccountNumber,
            "bankName" : requestData.bankName,
            "name" : requestData.name,
            "sourceNumber" : requestData.sourceNumber,
            "cardNo" : requestData.cardNo,
            "type" : requestData.type,
            "transferOnUs" : requestData.transferOnUs as Any,
            "transferOffUsSkn" : requestData.transferOffUsSkn as Any,
            //            "transferOffUsRtgs" : requestData.transferOffUsRtgs,
            "transactionDate" : requestData.transactionDate,
            "nominal" : requestData.nominal,
            "nominalSign" : requestData.nominalSign
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlSaveFavorite() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("SAVE FAVORITE SERVICE RESULST : \(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    completion(.success(httpResponse.statusCode))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
