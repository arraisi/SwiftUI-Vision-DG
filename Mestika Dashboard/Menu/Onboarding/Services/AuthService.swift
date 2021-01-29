//
//  AuthService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import Foundation

class AuthService {
    private init() {}
    
    static let shared = AuthService()
    
    func login(
        password: String,
        phoneNumber: String,
        fingerCode: String,
        completion: @escaping(Result<LoginCredentialResponse, ErrorResult>) -> Void) {
        // Body
        let body: [String: Any] = [
            "pwd": password
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        guard let url = URL.urlAuthLogin() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(.success(loginResponse!))
                }
                
                if (httpResponse.statusCode == 500) {
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
    
    func logout(completion: @escaping(Result<String, ErrorResult>) -> Void) {
        
        guard let url = URL.urlAuthLogout() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 401) {
                    completion(.success("Success"))
                }
                
//                if (httpResponse.statusCode == 200) {
//                    let loginResponse = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
//                    completion(.success(loginResponse!))
//                }
                
                if (httpResponse.statusCode == 500) {
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
