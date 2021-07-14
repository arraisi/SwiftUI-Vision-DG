//
//  EStatementService.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 08/06/21.
//

import Foundation

class EStatementService {
    private init() {}
    static let shared = EStatementService()
    
    // MARK: - GET LIST KARTKU KU
    func getListEStatement(accountNumber: String, completion: @escaping(Result<EStatementModel, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetEStateMent(accountNumber: accountNumber) else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("\nGET LIST ESTATEMENT HTTP RESPONSE: \(httpResponse.statusCode)")

                if (httpResponse.statusCode == 200) {
                    if let responseBody = try? JSONDecoder().decode(EStatementModel.self, from: BlowfishEncode().decrypted(data: data)!) {
                        print("RESPONSE BODY GET LIST ESTATEMENT \(responseBody)")
                        completion(.success(responseBody))
                    }
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }

                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }

                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }}
