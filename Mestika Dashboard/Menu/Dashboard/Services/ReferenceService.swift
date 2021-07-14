//
//  ReferenceService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/02/21.
//

import Foundation

class ReferenceService {
    private init() {}
    static let shared = ReferenceService()
    
    // MARK: - GET BANK REFERENCE
    func getBankReference(completion: @escaping(Result<BankReferenceResponse, NetworkError>) -> Void) {
        
        print("API GET BANK REFERENCE")
        
        guard let url = URL.urlBankReference() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let referenceResponse = try? JSONDecoder().decode(BankReferenceResponse.self, from: BlowfishEncode().decrypted(data: data)!)
            
            if referenceResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(referenceResponse!))
            }
            
        }.resume()
    }
}
