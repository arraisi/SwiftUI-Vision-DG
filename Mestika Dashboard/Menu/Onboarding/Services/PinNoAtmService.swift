//
//  PinNoAtmService.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/01/21.
//

import Foundation
import SwiftUI

class PinNoAtmService {
    
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    private init() {}
    
    static let shared = PinNoAtmService()
    
    // MARK : PIN VALIDATION.
    func validatePin(
        pin: String,
        cardNo: String,
        validateType: String,
        completion: @escaping(Result<Status, NetworkError>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "pin": pin,
            "cardNo":  cardNo
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // Url
        guard let url = URL.urlPINValidation() else {
            return completion(.failure(.badUrl))
        }
        
        // Params
        let paramsUrl = url.appending("validateType", value: validateType)
        
        // Method And Header
        var request = URLRequest(paramsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // Execution
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let pinResponse = try? JSONDecoder().decode(Status.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if pinResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(pinResponse!))
            }
            
        }.resume()
        
    }
    
    // MARK : PIN VALIDATION EXISTING.
    func validatePinNasabahExisting(
        atmData: AddProductATM,
        pin: String,
        cardNo: String,
        completion: @escaping(Result<Status, NetworkError>) -> Void) {
        
        // Body
        let body: [String: Any] = [
            "pin": [
                "pin": pin,
                "cardNo": cardNo
            ],
            "atm": [
                "atmAddressInput": atmData.atmAddressInput,
                "atmAddressKelurahanInput": atmData.atmAddressKelurahanInput,
                "atmAddressKecamatanInput": atmData.atmAddressKecamatanInput,
                "atmAddressKotaInput": atmData.atmAddressKotaInput,
                "atmAddressPropinsiInput": atmData.atmAddressPropinsiInput,
                "atmAddressPostalCodeInput": atmData.atmAddressPostalCodeInput,
                "atmAddressRtInput": atmData.atmAddressRtInput,
                "atmAddressRwInput": atmData.atmAddressRwInput,
                "atmName": atmData.atmName,
                "isNasabahMestika": true,
                "codeClass": atmData.productType,
                "imageDesign": atmData.imageDesign,
                "addressEqualToDukcapil": false
            ]
        ]
        
        print("body => \(body)")
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        // Url
        guard let url = URL.urlPINValidationNasabahExisting() else {
            return completion(.failure(.badUrl))
        }
        
        // Method And Header
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = finalBody
        
        // Execution
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let pinResponse = try? JSONDecoder().decode(Status.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if pinResponse == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(pinResponse!))
            }
            
        }.resume()
        
    }
}
