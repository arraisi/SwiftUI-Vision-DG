//
//  ATMService.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 23/11/20.
//

import Foundation

class ATMService {
    private init() {}
    
    static let shared = ATMService()
    
    // MARK : get response model of add product ATM.
    func postAddProductATM(dataRequest: AddProductATM, completion: @escaping(Result<GeneralResponse, NetworkError>) -> Void) {
        
        guard let url = URL.urlAddProductATM() else {
            return completion(.failure(.badUrl))
        }
        
        print("NIK \(dataRequest.nik)")
        
        var dataParam: [String : Any] = [
            "nik": dataRequest.nik,
            "isNasabahMestika": dataRequest.isNasabahMestika,
            "isVcall": dataRequest.isVcall,
            "codeClass": dataRequest.productType,
            "imageDesign": dataRequest.imageDesign,
            "atmName": dataRequest.atmName,
            "atmAddressInput": dataRequest.atmAddressInput,
            "atmAddressPostalCodeInput": dataRequest.atmAddressPostalCodeInput,
            "atmAddressRtInput": dataRequest.atmAddressRtInput,
            "atmAddressRwInput": dataRequest.atmAddressRwInput,
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
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString)
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
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            // MARK : change model response.
            let response = try? JSONDecoder().decode(JenisTabunganModel.self, from: data)
            
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
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
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
        
        guard let url = URL.urlFindListATMDesign(code: classCode) else {
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
