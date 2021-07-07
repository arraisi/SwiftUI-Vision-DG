//
//  AddressService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation
import SwiftyRSA

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
                    if let address = addressResponse {
                        completion(.success(address))
                        print("Succsess")
                        print(address[0].formatted_address)
                    }
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
    
    /* GET MASTER PROVINCE */
    func getAllProvince(completion: @escaping(Result<MasterProvinceResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetAllProvince() else {
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
                    let provinceResponse = try? JSONDecoder().decode(MasterProvinceResponse.self, from: data!)
                    completion(Result.success(provinceResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    /* GET MASTER REGENCY BY ID PROVINCE */
    func getAllRegencyByIdProvince(idProvince: String, completion: @escaping(Result<MasterRegencyResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetRegencyByIdProvince(idProvince: idProvince) else {
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
                    let regencyResponse = try? JSONDecoder().decode(MasterRegencyResponse.self, from: data!)
                    completion(Result.success(regencyResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    /* GET MASTER DISTRICT BY ID REGENCY */
    func getAllDistrictByIdRegency(idRegency: String, completion: @escaping(Result<MasterDistrictResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetDistrictByIdRegency(idRegency: idRegency) else {
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
                    let districtResponse = try? JSONDecoder().decode(MasterDistrictResponse.self, from: data!)
                    completion(Result.success(districtResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    /* GET MASTER VILAGE BY ID REGENCY */
    func getAllVilageByIdDistrict(idDistrict: String, completion: @escaping(Result<MasterVilageResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetVilageByIdDistrict(idDistrict: idDistrict) else {
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
                    let vilageResponse = try? JSONDecoder().decode(MasterVilageResponse.self, from: data!)
                    completion(Result.success(vilageResponse!))
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}
