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
    
    // MARK: - CHECK CUSTOMER
    func checkCustomer(completion: @escaping(Result<CustomerFromPhoenixResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetCustomerFromPhoenix() else {
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
                    print("OK 200")
                    if let profileResponse = try? JSONDecoder().decode(CustomerFromPhoenixResponse.self, from: data) {
                        completion(.success(profileResponse))
                    }
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - CHECK PROFILE
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
                    print("OK 200")
                    if let profileResponse = try? JSONDecoder().decode(ProfileResponseModel.self, from: data) {
                        completion(.success(profileResponse))
                    }
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - CHECK FREEZE ACCOUNT
    func checkFreeze(completion: @escaping(Result<FreezeAccountResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlCheckFreeze() else {
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
                    print("OK 200")
                    if let profileResponse = try? JSONDecoder().decode(FreezeAccountResponse.self, from: data) {
                        completion(.success(profileResponse))
                    }
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - CHECK FREEZE ACCOUNT
    func trace(data: DeviceTraceModel, completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        guard let url = URL.urlPostTrace() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        // MARK: BODY
        let body: [String: Any] = [
            "osVersion" : data.osVersion,
            "version": data.version,
            "sdk": data.sdk,
            "release": data.release,
            "device": data.device,
            "model": data.model,
            "product": data.product,
            "brand": data.brand,
            "display": data.display,
            "cpuAbi": data.cpuAbi,
            "cpuAbi2": data.cpuAbi2,
            "unknown": data.unknown,
            "hardware": data.hardware,
            "id": data.id,
            "manufacturer": data.manufacturer,
            "serial": data.serial,
            "user": data.user,
            "host": data.host,
            "latitude": data.latitude,
            "longitude": data.longitude,
            "carrier": data.carrier,
            "ip4": data.ip4,
            "ip6": data.ip6,
            "iccId": data.iccId
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\n\n RESPONSE TRACE DEVICE = \(httpResponse.statusCode)\n")
                
                if (httpResponse.statusCode == 200) {
                    print("OK 200")
                    if let profileResponse = try? JSONDecoder().decode(Status.self, from: data) {
                        completion(.success(profileResponse))
                    }
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - GET ACCOUNT BALANCE
    func getAccountBalance(completion: @escaping(Result<AccountBalanceResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlGetAccountBalance() else {
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
                    print("OK 200")
                    if let profileResponse = try? JSONDecoder().decode(AccountBalanceResponse.self, from: data) {
                        completion(.success(profileResponse))
                    }
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
