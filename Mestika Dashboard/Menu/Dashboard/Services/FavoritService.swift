//
//  FavoritService.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/02/21.
//

import Foundation

class FavoritService {
    
    private init() {}
    
    static let shared = FavoritService()
    
    // MARK: - GET LIST LAST TRANSACTION
    func getListLastTransaction(sourceNumber: String, completion: @escaping(Result<LastTransactionResponse, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "sourceNumber" : sourceNumber
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlLastTransaction() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET LIST LAST TRANSACTION SERVICE RESULT : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let lastTrxResponse = try? JSONDecoder().decode(LastTransactionResponse.self, from: data)
                    
                    if let _response = lastTrxResponse {
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
    
    // MARK: - GET LIST FAVORITE
    func getList(cardNo: String, sourceNumber: String, completion: @escaping(Result<[FavoritModelElement], ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "cardNo" : cardNo,
            "sourceNumber" : sourceNumber
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
                    
                    let favoriteListResponse = try? JSONDecoder().decode([FavoritModelElement].self, from: data)
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
    
    // MARK: - UPDATE FAVORITE
    func update(data: FavoritModelElement, name: String, completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
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
    
    // MARK: - UPDATE FAVORITE
    func updateWithParam(id: String, cardNo: String, sourceNumber: String, name: String, completion: @escaping(Result<Int, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "id" : id,
            "cardNo": cardNo,
            "sourceNumber": sourceNumber,
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
    func remove(data: FavoritModelElement, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
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
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
                }
                
                // MARK : change model response.
                let response = try? JSONDecoder().decode(Status.self, from: data)
                
                print(response?.code ?? "NO CODE")
                
                if let status = response {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 400  {
                        completion(.success(status))
                    } else {
                        // if we're still here it means there was a problem
                        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    }
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
    
    // MARK: - SAVE FAVORITE ON USE
    func save(data: TransferOnUsModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "bankAccountNumber" : "001",
            "bankName" : "MESTIKA",
            "name" : data.destinationName,
            "sourceNumber" : data.sourceNumber,
            "cardNo" : data.cardNo,
            "type" : data.transferType,
            "transferOnUs" : [
                "cardNo" : data.cardNo,
                "ref": data.ref,
                "nominal": data.amount,
                "currency": data.currency,
                "sourceNumber": data.sourceNumber,
                "destinationNumber": data.destinationNumber,
                "berita": "testing"
            ],
            "transactionDate" : "2020-01-10 10:20:57",
            "nominal" : data.amount,
            "nominalSign" : data.amount
        ]
        
        print("TRANSFER ON US body => \(body)")
        
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
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\nSAVE FAVORITE SERVICE RESULST : \(httpResponse.statusCode)\n")
                
                // MARK : change model response.
                let response = try? JSONDecoder().decode(Status.self, from: data)
                
                print("HTTP RESPONSE SAVE FAVORITE \(httpResponse.statusCode)")
                print(response?.code ?? "NO CODE")
                
                if let status = response {
                    if status.code == "200" || httpResponse.statusCode == 200  {
                        completion(.success(status))
                    }
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
    
    // MARK: - SAVE FAVORITE RTGS
    func saveFavoriteRtgs(data: TransferOffUsModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "bankAccountNumber" : "001",
            "bankName" : data.bankName,
            "name" : data.destinationName,
            "sourceNumber" : data.sourceNumber,
            "cardNo" : data.cardNo,
            "type" : data.transferType,
            "transferOffUsRtgs": [
                "ref": "1",
                "cardNo": data.cardNo,
                "nominal": data.amount,
                "currency": "360",
                "sourceNumber": data.sourceNumber,
                "destinationBankCode": data.destinationBankCode,
                "ultimateBeneficiaryName": data.destinationName,
                "description": data.notes,
                "flagWargaNegara": "W",
                "flagResidenceDebitur": "R",
                "destinationBankMemberName": data.combinationBankName,
                "destinationBankName": data.bankName,
                "destinationBankBranchName": "DAGO",
                "accountTo": data.destinationNumber,
                "addressBeneficiary1": data.addressOfDestination,
                "addressBeneficiary2": "",
                "addressBeneficiary3": ""
            ],
            "transactionDate" : "2020-01-10 10:20:57",
            "nominal" : data.amount,
            "nominalSign" : data.amount
        ]
        
        print("TRANSFER ON US body => \(body)")
        
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
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\nSAVE FAVORITE SERVICE RESULST : \(httpResponse.statusCode)\n")
                
                // MARK : change model response.
                let response = try? JSONDecoder().decode(Status.self, from: data)
                
                print(response?.code ?? "NO CODE")
                
                if let status = response {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 400  {
                        completion(.success(status))
                    }
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
    
    // MARK: - SAVE FAVORITE SKN
    func saveFavoriteSkn(data: TransferOffUsModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "bankAccountNumber" : "001",
            "bankName" : data.bankName,
            "name" : data.destinationName,
            "sourceNumber" : data.sourceNumber,
            "cardNo" : data.cardNo,
            "type" : data.transferType,
            "transferOffUsSkn": [
                "ref": "1",
                "cardNo": data.cardNo,
                "nominal": data.amount,
                "currency": "360",
                "sourceNumber": data.sourceNumber,
                "destinationBankCode": data.destinationBankCode,
                "ultimateBeneficiaryName": data.destinationName,
                "description": data.notes,
                "flagWargaNegara": "W",
                "flagResidenceDebitur": "R",
                "digitSign": "C",
                "typeOfBusiness": "A",
                "cityCode": "1234",
                "provinceCode": "1234",
                "branchCode": "1234",
                "clearingCode": data.kliringCode,
                "accountTo": data.destinationNumber,
                "flagResidenceCreditur": "R"
            ],
            "transactionDate" : "2020-01-10 10:20:57",
            "nominal" : data.amount,
            "nominalSign" : data.amount
        ]
        
        print("TRANSFER ON US body => \(body)")
        
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
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\nSAVE FAVORITE SERVICE RESULST : \(httpResponse.statusCode)\n")
                
                // MARK : change model response.
                let response = try? JSONDecoder().decode(Status.self, from: data)
                
                print(response?.code ?? "NO CODE")
                
                if let status = response {
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 400  {
                        completion(.success(status))
                    }
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
