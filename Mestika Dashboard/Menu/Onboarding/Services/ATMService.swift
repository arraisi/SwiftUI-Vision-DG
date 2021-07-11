//
//  ATMService.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 23/11/20.
//

import Foundation
import SwiftyRSA

class ATMService {
    private init() {}
    
    static let shared = ATMService()
    var defaults = UserDefaults.standard
    
    // MARK : get response model of add product ATM.
    func postAddProductATM(dataRequest: AddProductATM, completion: @escaping(Result<GeneralResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlAddProductATM() else {
            return completion(.failure(.badUrl))
        }
        
        print("NIK \(dataRequest.nik)")
        
        let dataParam: [String : Any] = [
            "nik": dataRequest.nik,
            "isNasabahMestika": dataRequest.isNasabahMestika,
            "isVcall": dataRequest.isVcall,
            "codeClass": dataRequest.productType,
            "imageDesign": dataRequest.imageDesign,
            "atmName": dataRequest.atmName,
            "atmAddressInput": dataRequest.atmAddressInput,
            "atmAddressPostalCodeInput": dataRequest.atmAddressPostalCodeInput,
            "atmAddressRtInput": "00",
            "atmAddressRwInput": "00",
            "atmAddressKelurahanInput": dataRequest.atmAddressKelurahanInput,
            "atmAddressKecamatanInput": dataRequest.atmAddressKecamatanInput,
            "atmAddressKotaInput": dataRequest.atmAddressKotaInput,
            "atmAddressPropinsiInput": dataRequest.atmAddressPropinsiInput,
            "addressEqualToDukcapil": dataRequest.addressEqualToDukcapil
        ]
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: dataParam, options: .prettyPrinted)
            
            _ = String(data: jsonData, encoding: String.Encoding.ascii)
            request.httpBody = jsonData
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(.decodingError))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode(GeneralResponse.self, from: data)
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
        }.resume()
    }
    
    // MARK : get response model of list ATM.
    func getListATM(completion: @escaping(Result<[ATMModel], NetworkError>) -> Void) {
        
        guard let url = URL.urlGetListATM() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode([ATMModel].self, from: data)
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
        }.resume()
    }
    
    // MARK : get response model of list Jenis Tabungan.
    func getListJenisTabungan(completion: @escaping(Result<JenisTabunganModel, NetworkError>) -> Void) {
        
        guard let url = URL.urlGetListJenisTabungan() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if let jwtToken = httpResponse.allHeaderFields["Authorization"] as? String {
                    print("Token From POST OTP")
                    print(jwtToken)
                    self.defaults.set(jwtToken, forKey: defaultsKeys.keyToken)
                }
                
                if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
                    print("VALUE XSFR")
                    print("\(cookie.value)")
                    self.defaults.set(cookie.value, forKey: defaultsKeys.keyXsrf)
                }
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode(JenisTabunganModel.self, from: data)
            print(String(data: data, encoding: .utf8))
            if response == nil {
                print("\nError Decoding")
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
        }.resume()
    }
    
    func getListJenistATM(completion: @escaping(Result<JenisATMModel, NetworkError>) -> Void) {
        guard let url = URL.urlFindListATM() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if let jwtToken = httpResponse.allHeaderFields["Authorization"] as? String {
                    print("Token From POST OTP")
                    print(jwtToken)
                    self.defaults.set(jwtToken, forKey: defaultsKeys.keyToken)
                }
                
                if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
                    print("VALUE XSFR")
                    print("\(cookie.value)")
                    self.defaults.set(cookie.value, forKey: defaultsKeys.keyXsrf)
                }
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode(JenisATMModel.self, from: data)
            
            if response == nil {
                print("\n get list jenis atm nil")
                completion(.failure(.decodingError))
            } else {
                print("\n\n succes get list jenis atm")
                print("\n jenis ATM Count : \(String(describing: response?.count))\n")
                completion(.success(response!))
            }
        }.resume()
    }
    
    // MARK : get response model of list ATM Design.
    func getListATMDesign(classCode: String, completion: @escaping(Result<[DesainAtmModel], NetworkError>) -> Void) {
        
        guard let url = URL.urlFindListATMDesign() else {
            return completion(.failure(.badUrl))
        }
        
        let paramsUrl = url.appending("classCode", value: classCode)
        
        var request = URLRequest(paramsUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("response: \(String(describing: response))")
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if let jwtToken = httpResponse.allHeaderFields["Authorization"] as? String {
                    print("Token From POST OTP")
                    print(jwtToken)
                    self.defaults.set(jwtToken, forKey: defaultsKeys.keyToken)
                }
                
                if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == "XSRF-TOKEN" }) {
                    print("VALUE XSFR")
                    print("\(cookie.value)")
                    self.defaults.set(cookie.value, forKey: defaultsKeys.keyXsrf)
                }
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode([DesainAtmModel].self, from: data)
            
            if response == nil {
                print("\n get list desain atm nil\n")
                completion(.failure(.decodingError))
            } else {
                print("\n\n success get list desain atm")
                print("\n desain ATM Count : \(String(describing: response?.count))\n")
                completion(.success(response!))
            }
        }.resume()
    }
}
