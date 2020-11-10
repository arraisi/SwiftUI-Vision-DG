//
//  OtpService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

class OtpService {
    
    private init() {}
    
    static let shared = OtpService()
    
    func getRequestOtp(otpRequest: OtpRequest, completion: @escaping(Result<OtpResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlGetRequestOtp() else {
            return completion(.failure(.badUrl))
        }
        
//        let body = "destination=\(otpRequest.destination)&type=\(otpRequest.type)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("1", forHTTPHeaderField: "X-Device-ID")
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
            
            if otpResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(otpResponse!))
            }
            
        }.resume()
    }
}
