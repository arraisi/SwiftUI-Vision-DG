//
//  OtpService.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation
import SwiftUI

class OtpService {
    
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    private init() {}
    
    static let shared = OtpService()
    
    /* VALIDATE CODE OTP */
    func validateOtp(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        type: String,
        completion: @escaping(Result<OtpResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "code": code,
            "destination": destination.trimmingCharacters(in: .whitespacesAndNewlines),
            "reference": reference,
            "timeCounter": timeCounter,
            "tryCount": tryCount,
            "nik": ""
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        guard let url = URL.urlOTP() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("type", value: type)
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
                    completion(.success(otpResponse!))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
        
    }
    
    /* GET CODE OTP */
    func getRequestOtp(otpRequest: OtpRequest, completion: @escaping(Result<OtpResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlOTP() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let finalUrl = url
            .appending("trytime", value: otpRequest.trytime.numberString)
            .appending("destination", value: otpRequest.destination)
            .appending("type", value: otpRequest.type)
        
        var request = URLRequest(finalUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
                    if otpResponse == nil {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    } else {
                        completion(.success(otpResponse!))
                    }
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode > 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
            }
            
        }.resume()
    }
    
    /* VALIDATE CODE OTP FOR ACC OR REKENING */
    func validateOtpAccOrRek(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        type: String,
        accValue: String,
        completion: @escaping(Result<OtpResponse, NetworkError>) -> Void) {
        
        let body: [String: Any] = [
            "code": code,
            "destination":  destination,
            "reference": reference,
            "timeCounter": timeCounter,
            "tryCount": tryCount,
            "nik": ""
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        guard let url = URL.urlOTP() else {
            return completion(.failure(.badUrl))
        }
        
        let paramsUrl = url
            .appendingPathComponent("/postacc")
            .appending("accValue", value: accValue)
            .appending("trytime", value: tryCount.numberString)
            .appending("accType", value: type)
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
            
            if otpResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(otpResponse!))
            }
            
        }.resume()
        
    }
    
    /* GET CODE OTP FOR ACC OR REKENING */
    func getRequestOtpAccOrRek(otpRequest: OtpRequest, completion: @escaping(Result<OtpResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlOTP() else {
            return completion(.failure(.badUrl))
        }
        
        let finalUrl = url
            .appendingPathComponent("/getacc")
            .appending("trytime", value: otpRequest.trytime.numberString)
            .appending("accValue", value: otpRequest.destination)
            .appending("accType", value: otpRequest.type)
        
        var request = URLRequest(finalUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
            
            if otpResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(otpResponse!))
            }
            
        }.resume()
    }
    
    /* GET CODE OTP FOR LOGIN */
    func getRequestOtpLogin(completion: @escaping(Result<OtpResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlAuthRequestOTP() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
                    if otpResponse == nil {
                        completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                    } else {
                        completion(.success(otpResponse!))
                    }
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode > 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
            }
            
        }.resume()
    }
    
    /* VALIDATE CODE OTP FOR LOGIN */
    func validateOtpLogin(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        completion: @escaping(Result<OtpResponse, NetworkError>) -> Void) {
        
        let body: [String: Any] = [
            "code": code,
//            "destination": "+62" + destination.trimmingCharacters(in: .whitespacesAndNewlines),
            "destination": destination.trimmingCharacters(in: .whitespacesAndNewlines),
            "reference": reference,
            "timeCounter": timeCounter,
            "tryCount": tryCount,
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        guard let url = URL.urlAuthValidationOTP() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            let otpResponse = try? JSONDecoder().decode(OtpResponse.self, from: data)
            
            if otpResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(otpResponse!))
            }
            
        }.resume()
        
    }
}
