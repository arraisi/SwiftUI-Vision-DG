//
//  ATMService.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 23/11/20.
//

import Foundation

class ATMService {
    private init() {}
    
    static let shared = ATMService()
    
    // MARK : get response model.
    func postAddProductATM(dataRequest: AddProductATM, completion: @escaping(Result<GeneralResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlAddProductATM() else {
            return completion(.failure(.badUrl))
        }
        
        // MARK : serialize model data
        let finalBody = try! JSONEncoder().encode(dataRequest)
        let json = String(data: finalBody, encoding: String.Encoding.utf8)
        print(json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("1", forHTTPHeaderField: "X-Device-ID")
        request.addValue("1", forHTTPHeaderField: "X-Firebase-ID")
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.httpBody = finalBody
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode(GeneralResponse.self, from: data)
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
        }.resume()
    }
}