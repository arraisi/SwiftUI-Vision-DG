//
//  AssetsService.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 08/10/20.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decodingError
    case noData
    case notFound
}

class AssetsService {
    
    private init() {}
    
    static let shared = AssetsService()
    
    func getSliderAssets(completion: @escaping(Result<[SliderAssetsResponse]?, NetworkError>) -> Void) {
        print("API ASSETS")
        
        guard let url = URL.urlForSliderAssets() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let assetsResponse = try? JSONDecoder().decode([SliderAssetsResponse].self, from: data)
            
            if assetsResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(assetsResponse!))
            }
            
        }.resume()
    }
}
