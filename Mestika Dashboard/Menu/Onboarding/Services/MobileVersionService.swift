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
        
        let preferences = UserDefaults.standard
        let token = "X-XSRF-TOKEN"
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data, error == nil else {
                print("RTO")
                return completion(.failure(.noData))
            }
            
            if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
                print("VALUE XSFR")
                print("\(cookie.value)")
                preferences.set(cookie.value, forKey: token)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("VALUE VERSION")
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
