//
//  ProfileService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/02/21.
//

import Foundation
import CoreLocation
import CoreTelephony
import SwiftUI

class ProfileService {
    
    private init() {}
    
    static let shared = ProfileService()
    
    func updateCustomerPhoenix(body: [String: Any], completion: @escaping(Result<Status, ErrorResult>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        let jsonString = String(data: jsonData!, encoding: .utf8)
        print("\n\n json update customer phoenix")
        print(jsonString ?? "")
        print("\n\n")
        
        guard let url = URL.urlUpdateCustomerPhoenix() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")

                if (httpResponse.statusCode == 200) {
                    print("http status OK 200")
                    if let responseBody = try? JSONDecoder().decode(Status.self, from: data) {
                        print("body status \(responseBody)")
                        completion(.success(responseBody))
                    }
                }
                
                if (httpResponse.statusCode == 400) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }

                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 406) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }

                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }

        }.resume()
    }
    
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
                print("\n\n RESPONSE CHECK FREEZE = \(httpResponse.statusCode)\n")
                
                if (httpResponse.statusCode == 200) {
                    print("OK 200")
                    print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
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
        
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        guard let url = URL.urlPostTrace() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        // MARK: BODY
        let body: [String: Any] = [
            "osVersion" : data.osVersion,
            "version": data.version,
            "sdk": "Swift 5.1",
            "release": data.release,
            "device": UIDevice().type.rawValue,
            "model": data.model,
            "product": data.product,
            "brand": data.brand,
            "display": data.display,
            "cpuAbi": data.cpuAbi,
            "cpuAbi2": "armeabi-v7",
            "unknown": data.unknown,
            "hardware": data.hardware,
            "id": UIDevice().identifierForVendor?.uuidString ?? "",
            "manufacturer": data.manufacturer,
            "serial": data.serial,
            "user": data.user,
            "host": data.host,
            "latitude": latitude ?? "",
            "longitude": longitude ?? "",
            "carrier": carrier?.carrierName ?? "",
            "ip4": UIDevice().ipAddress() ?? "",
            "ip6": UIDevice().ipAddress() ?? "",
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
