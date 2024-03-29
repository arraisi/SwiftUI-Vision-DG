//
//  HistoryTransactionServices.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import Foundation

class HistoryTransactionServices {
    
    private init() {}
    
    static let shared = HistoryTransactionServices()
    
    // MARK: - GET LIST FAVORITE
    func getList(
        cardNo: String,
        sourceNumber: String,
        dateFrom: String,
        dateTo: String,
        lastRecordDate: String,
        lastRecordPostingDate: String,
        lastRecordTraceNo: String,
        completion: @escaping(Result<HistoryTransactionModel, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "cardNo": cardNo,
            "dateFrom": dateFrom,
            "dateTo": dateTo,
            "lastRecordDate": "",
            "lastRecordPostingDate": "",
            "lastRecordTraceNo": "",
            "sourceNumber": sourceNumber
        ]
        
        print("\n\nbody get list history => \(body)\n\n")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // MARK: URL
        guard let url = URL.urlGetListHistory() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = BlowfishEncode().encrypted(data: finalBody)
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET LIST HISTORY SERVICE RESULST : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let historyListResponse = try? JSONDecoder().decode(HistoryTransactionModel.self, from: BlowfishEncode().decrypted(data: data)!)
                    print("HISTORY balance \(String(describing: historyListResponse?.balance))\n\n")
                    print("HISTORY Count \(String(describing: historyListResponse?.historyList?.count))\n\n")
                    
                    if let histories = historyListResponse {
                        completion(.success(histories))
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
    func findAll(completion: @escaping(Result<HistoryModel, ErrorResult>) -> Void) {
        
        // MARK: URL
        guard let url = URL.urlGetAllHistory() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nFIND ALL HISTORY SERVICE RESULST : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {
                    return completion(Result.failure(ErrorResult.network(string: "NO DATA")))
                }
                
                if (httpResponse.statusCode == 200) {
                    
                    let history = try? JSONDecoder().decode(HistoryModel.self, from: BlowfishEncode().decrypted(data: data)!)
                    
                    if let _history = history {
                        print("SUCCESS FIND ALL HISTORY")
                        completion(.success(_history))
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
}
