//
//  MobileVersionService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation

class MobileVersionService {
    
    private init() {}
    
    static let shared = MobileVersionService()
    
    /* GET MOBILE VERSION */
    func getVersion(completion: @escaping(Result<MobileVersionResponse, NetworkError>) -> Void) {
    
        guard let url = URL.urlMobileVersion() else {
            return completion(.failure(.badUrl))
        }
        
        let paramsUrl = url.appending("osType", value: "ios")
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let versionResponse = try? JSONDecoder().decode(MobileVersionResponse.self, from: data)
            
            if versionResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(versionResponse!))
            }
        }.resume()
    }
}
