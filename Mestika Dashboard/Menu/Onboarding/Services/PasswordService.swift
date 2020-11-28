//
//  PasswordService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 28/11/20.
//

import Foundation

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
        
        let finalUrl = url.appending("password", value: password)
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
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
                
                if (httpResponse.statusCode == 5000) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
