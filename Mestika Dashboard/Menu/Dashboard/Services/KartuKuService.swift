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
            
        }.resume()
    }
}
