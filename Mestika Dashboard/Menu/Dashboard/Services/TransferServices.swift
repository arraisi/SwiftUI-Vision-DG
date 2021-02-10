//
//  TransferServices.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation

class TransferServices {
    private init() {}
    static let shared = TransferServices()
    
    // MARK: - POST TRANSFER ONUS
    func transferOnUs(transferData: TransferOnUsModel,
                      completion: @escaping(Result<TransferOnUsResponse, NetworkError>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": "5058200000000758",
            "ref": "1",
            "nominal": "500000",
            "currency": "360",
            "sourceNumber": "87000000126",
            "destinationNumber": "87000000142",
            "berita": "testing",
            "pin": "pin"
        ]
        
        guard let url = URL.urlTransferOverbooking() else {
            return completion(.failure(.badUrl))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
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
            
            let response = try? JSONDecoder().decode(TransferOnUsResponse.self, from: data)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
            }
            
            if response == nil {
                completion(.failure(.decodingError))
            } else {
                completion(.success(response!))
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER RTGS
    func transferRtgs(transferData: TransferOffUsModel,
                      completion: @escaping(Result<TransferOnUsResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "ref": "",
            "cardNo": transferData.sourceNumber,
            "nominal": transferData.amount,
            "currency": "360",
            "sourceNumber": transferData.sourceNumber,
            "destinationBankCode": transferData.destinationBankCode,
            "ultimateBeneficiaryName": transferData.destinationName,
            "description": transferData.notes,
            "flagWargaNegara": "W",
            "flagResidenceDebitur": "R",
            "destinationBankMemberName": transferData.combinationBankName,
            "destinationBankName": transferData.bankName,
            "destinationBankBranchName": "DAGO",
            "accountTo": transferData.destinationNumber,
            "addressBeneficiary1": transferData.addressOfDestination,
            "addressBeneficiary2": "BANDUNG",
            "addressBeneficiary3": "",
            "typeOfBeneficiary": transferData.typeDestination,
            "pin": transferData.pin
        ]
        
        guard let url = URL.urlTransferRtgs() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString)
            request.httpBody = jsonData
        } catch let error {
            print(error.localizedDescription)
            completion(Result.failure(ErrorResult.parser(string: "ERROR DECODING")))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let transferResponse = try? JSONDecoder().decode(TransferOnUsResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER SKN
    func transferSkn(transferData: TransferOffUsModel,
                     completion: @escaping(Result<TransferOnUsResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "accountTo": transferData.destinationNumber,
            "branchCode": "1234",
            "cardNo": transferData.sourceNumber,
            "cityCode": "1234",
            "clearingCode": transferData.kliringCode,
            "currency": "360",
            "description": transferData.notes,
            "destinationBankCode": transferData.combinationBankName,
            "digitSign": "C",
            "flagResidenceCreditur": "R",
            "flagResidenceDebitur": "R",
            "flagWargaNegara": "W",
            "nominal": transferData.amount,
            "pin": transferData.pin,
            "provinceCode": "1234",
            "ref": "",
            "typeOfBeneficiary": transferData.typeDestination,
            "typeOfBusiness": "A",
            "sourceNumber": "87000000126",
            "ultimateBeneficiaryName": transferData.destinationName
        ]
        
        guard let url = URL.urlTransferSkn() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        do {
            // MARK : serialize model data
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            print(jsonString)
            request.httpBody = jsonData
        } catch let error {
            print(error.localizedDescription)
            completion(Result.failure(ErrorResult.parser(string: "ERROR DECODING")))
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    let transferResponse = try? JSONDecoder().decode(TransferOnUsResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
