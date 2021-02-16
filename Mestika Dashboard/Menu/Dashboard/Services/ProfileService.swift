//
//  ProfileService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/02/21.
//

import Foundation

class ProfileService {
    
    private init() {}
    
    static let shared = ProfileService()
    
    func checkProfile(completion: @escaping(Result<ProfileResponseModel, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetProfile() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n\n RESPONSE GET PROFILES = \(httpResponse.statusCode)\n")
                
                if (httpResponse.statusCode == 200) {
                    let profileResponse = try? JSONDecoder().decode(ProfileResponseModel.self, from: data)
                    completion(.success(profileResponse!))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
