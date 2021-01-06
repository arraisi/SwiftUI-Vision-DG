//
//  AddressService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation

class AddressService {
    
    private init() {}
    
    static let shared = AddressService()
    
    /* GET ADDRESS SUGESTION RESULT */
    func getAddressSugestionResult(addressInput: String, completion: @escaping(Result<[AddressSugestionResultResponse]?, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetSuggestionAddressResult() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("query", value: addressInput)
        
        var request = URLRequest(paramsUrl)
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
                    let addressResponse = try? JSONDecoder().decode([AddressSugestionResultResponse].self, from: data!)
                    completion(.success(addressResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    /* GET ADDRESS SUGESTION */
    func getAddressSugestion(addressInput: String, completion: @escaping(Result<[AddressSugestionResponse]?, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetSuggestionAddress() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("address", value: addressInput)
        
        var request = URLRequest(paramsUrl)
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
                    let addressResponse = try? JSONDecoder().decode([AddressSugestionResponse].self, from: data!)
                    completion(.success(addressResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}
