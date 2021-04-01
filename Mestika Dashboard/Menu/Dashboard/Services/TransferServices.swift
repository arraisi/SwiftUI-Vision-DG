//
//  TransferServices.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation
import Combine
import SwiftyRSA

class TransferServices {
    private init() {}
    static let shared = TransferServices()
    
    func encryptPassword(password: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: password, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
        //        self.registerData.password = base64String
    }
    
    // MARK: - GET LIMIT TRANSACTION
    func getLimitTransaction(classCode: String, completion: @escaping(Result<LimitTransactionResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlLimitTransaction() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("classCode", value: "70")
        
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
                    let limitResponse = try? JSONDecoder().decode(LimitTransactionResponse.self, from: data!)
                    if let limit = limitResponse {
                        completion(.success(limit))
                    }
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - POST TRANSFER ONUS INQUIRY
    func transferOnUsInquiry(transferData: TransferOnUsModel,
                      completion: @escaping(Result<InquiryTransferResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": " ",
            "nominal": "1",
            "currency": "360",
            "sourceNumber": "1",
            "destinationNumber": transferData.destinationNumber,
            "pin": "pin"
        ]
        
        guard let url = URL.urlTransferOverbookingInquiry() else {
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
            print(jsonString as Any)
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
                    let transferResponse = try? JSONDecoder().decode(InquiryTransferResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode > 300) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER ONUS
    func transferOnUs(transferData: TransferOnUsModel,
                      completion: @escaping(Result<TransferOnUsResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": transferData.cardNo,
            "ref": "1",
            "nominal": transferData.amount,
            "currency": "360",
            "sourceNumber": transferData.sourceNumber,
            "destinationNumber": transferData.destinationNumber,
            "berita": transferData.notes,
            "pin": encryptPassword(password: transferData.pin)
        ]
        
        guard let url = URL.urlTransferOverbooking() else {
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
            print(jsonString as Any)
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
                    print("ON Success")
                    let transferResponse = try? JSONDecoder().decode(TransferOnUsResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER RTGS
    func transferRtgs(transferData: TransferOffUsModel,
                      completion: @escaping(Result<TransferRtgsExecResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "ref": "1",
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
            "pin": encryptPassword(password: transferData.pin)
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
            print(jsonString as Any)
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
                    print("On Success")
                    let transferResponse = try? JSONDecoder().decode(TransferRtgsExecResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER SKN
    func transferSkn(transferData: TransferOffUsModel,
                     completion: @escaping(Result<TransferSknExecResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "accountTo": transferData.destinationNumber,
            "branchCode": "1234",
            "cardNo": transferData.cardNo,
            "cityCode": "1234",
            "clearingCode": transferData.kliringCode,
            "currency": "360",
            "description": transferData.notes,
            "destinationBankCode": "123",
            "digitSign": "C",
            "flagResidenceCreditur": "R",
            "flagResidenceDebitur": "R",
            "flagWargaNegara": "W",
            "nominal": transferData.amount,
            "pin": encryptPassword(password: transferData.pin),
            "provinceCode": "1234",
            "ref": "",
            "typeOfBeneficiary": transferData.typeDestination,
            "typeOfBusiness": "A",
            "sourceNumber": transferData.sourceNumber,
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
            print(jsonString as Any)
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
                    let transferResponse = try? JSONDecoder().decode(TransferSknExecResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
