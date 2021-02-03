//
//  TransferServices.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation

class TransferServices {
    private init() {}
    static let shared = TransferServices()
    
    func transferOnUs(transferData: TransferOnUsModel,
                      completion: @escaping(Result<TransferOnUsResponse, NetworkError>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": "5058200000000758",
            "ref": "1",
            "nominal": "500000",
            "currency": "360",
            "sourceNumber": "87000000126",
            "destinationNumber": "87000000142",
            "berita": "testing",
            "pin": "pin"
        ]
        
        guard let url = URL.urlTransferOverbooking() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString)
            request.httpBody = jsonData
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(.decodingError))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(TransferOnUsResponse.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
            
        }.resume()
    }
}
