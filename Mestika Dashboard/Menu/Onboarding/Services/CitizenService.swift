//
//  CitizenService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation
import SwiftyRSA

class CitizenService {
    
    private init() {}
    
    static let shared = CitizenService()
    
    func checkNIK(nik: String, phone: String, isNasabah: Bool, completion: @escaping(Result<CheckNIKResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlCitizen() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        print("NIK : \(nik)")
        
//        let finalUrl = url.appending("nik", value: nik)
        
        let finalUrlExisting = url.appending("nik", value: nik).appending("phoneNumber", value: isNasabah ? phone : "")
        
        var request = URLRequest(finalUrlExisting)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let citizenResponse = try? JSONDecoder().decode(CheckNIKResponse.self, from: data)
                    completion(.success(citizenResponse!))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    _ = try? JSONDecoder().decode(Status.self, from: data)
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
        
    }
}
