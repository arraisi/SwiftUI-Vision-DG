//
//  CitizenService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation

class CitizenService {
    
    private init() {}
    
    static let shared = CitizenService()
    
    func checkNIK(nik: String, completion: @escaping(Result<CheckNIKResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlCitizen() else {
            return completion(.failure(.badUrl))
        }
        
        print("NIK : \(nik)")
        
        let finalUrl = url.appending("nik", value: nik)
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        request.addValue("*/*", forHTTPHeaderField: "accept")
        
        print(request.url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let citizenResponse = try? JSONDecoder().decode(CheckNIKResponse.self, from: data)
            
//            if citizenResponse == nil {
//                completion(.failure(.decodingError))
//            } else {
//                completion(.success(citizenResponse!))
//            }
            completion(.success(citizenResponse!))
        }.resume()
        
    }
    
}
