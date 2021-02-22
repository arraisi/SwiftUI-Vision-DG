//
//  KartuKuService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/02/21.
//

import Foundation

class KartuKuService {
    private init() {}
    static let shared = KartuKuService()
    
    // MARK: - GET LIST KARTKU KU
    func getListKartuKu(completion: @escaping(Result<KartuKuResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetListKartuKu() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("response: \(String(describing: response))")
            
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let kartuKuResponse = try? JSONDecoder().decode(KartuKuResponse.self, from: data!)
                    if let kartuKu = kartuKuResponse {
                        completion(.success(kartuKu))
                    }
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}
