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
        
        let paramsUrl = url.appending("type", value: type)
        
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
    
    /* GET CODE OTP */
    func getRequestOtp(otpRequest: OtpRequest, completion: @escaping(Result<OtpResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlOTP() else {
            return completion(.failure(.badUrl))
        }
        
        let finalUrl = url
            .appending("trytime", value: otpRequest.trytime.numberString)
            .appending("destination", value: otpRequest.destination)
            .appending("type", value: otpRequest.type)
        
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
}
