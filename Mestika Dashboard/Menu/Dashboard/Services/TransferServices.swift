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
    
    // MARK: - GET FEE REPLACEMENT CARD
    func getFeeReplacement(classCode: String, completion: @escaping(Result<FeeCardReplacementResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlReplacementFee() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("classCode", value: classCode)
        
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
                    let limitResponse = try? JSONDecoder().decode(FeeCardReplacementResponse.self, from: data!)
                    if let limit = limitResponse {
                        completion(.success(limit))
                    }
                } else {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - GET LIMIT TRANSACTION
    func getLimitTransaction(classCode: String, completion: @escaping(Result<LimitTransactionResponse, ErrorResult>) -> Void) {
        
        guard let url = URL.urlLimitTransaction() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("classCode", value: classCode)
        
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
            "sourceNumber": transferData.sourceNumber,
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
    
    // MARK: - POST TRANSFER IBFT INQUIRY
    func transferIbftInquiry(transferData: TransferOffUsModel,
                             completion: @escaping(Result<TransferIbftInquiryResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "destinationAccountNumber": transferData.destinationNumber,
            "destinationBank": transferData.destinationBankCode,
            "sourceAccountNumber": transferData.sourceNumber,
            "transactionAmount": transferData.amount,
            "transactionDetails": ""
        ]
        
        guard let url = URL.urlTransferIbftInquiry() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        let paramsUrl = url.appending("type", value: transferData.transactionType.lowercased())
        
        var request = URLRequest(paramsUrl)
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
                    let transferResponse = try? JSONDecoder().decode(TransferIbftInquiryResponse.self, from: data)
                    completion(.success(transferResponse!))
                }
                
                if (httpResponse.statusCode > 200) {
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
            "ref": transferData.ref,
            "nominal": transferData.amount.replacingOccurrences(of: ".", with: ""),
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
                    print("ASUU")
                    
                    print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                    
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
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 504) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER IBFT
    func transferIbft(transferData: TransferOffUsModel,
                      completion: @escaping(Result<TransferIbftExecResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "destinationAccountName": transferData.destinationName,
            "destinationAccountNumber": transferData.destinationNumber,
            "destinationBank": transferData.destinationBankCode,
            "pinTrx": encryptPassword(password: transferData.pin),
            "sourceAccountName": transferData.sourceAccountName,
            "sourceAccountNumber": transferData.sourceNumber,
            "sourceBank": "151",
            "transactionAmount": transferData.amount,
            "transactionDetails": "",
            "transactionFee": transferData.adminFee,
            "reffNumber": transferData.ref
        ]
        
        guard let url = URL.urlTransferIbft() else {
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
                    let transferResponse = try? JSONDecoder().decode(TransferIbftExecResponse.self, from: data)
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
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 503) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 504) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST TRANSFER RTGS
    func transferRtgs(transferData: TransferOffUsModel,
                      completion: @escaping(Result<TransferRtgsExecResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "ref": transferData.ref,
            "cardNo": transferData.cardNo,
            "nominal": transferData.amount,
            "currency": "360",
            "sourceNumber": transferData.sourceNumber,
            "destinationBankCode": transferData.destinationBankCode,
            "ultimateBeneficiaryName": transferData.destinationName,
            "description": transferData.notes,
            "flagWargaNegara": "W",
            "flagResidenceDebitur": "R",
            "destinationBankMemberName": transferData.bankName,
            "destinationBankName": transferData.bankName,
            "destinationBankBranchName": transferData.bankName,
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
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 500) {
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
            "ref": transferData.ref,
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
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 500) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST MOVE BALANCE LIKE ON US API
    func moveBalance(transferData: MoveBalancesModel,
                     completion: @escaping(Result<TransferOnUsResponse, ErrorResult>) -> Void) {
        
        let body: [String: Any] = [
            "cardNo": transferData.cardNo,
            "ref": "1",
            "nominal": transferData.amount.replacingOccurrences(of: ".", with: ""),
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
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
    
    // MARK: - POST MOVE BALANCE LIKE ON US API
    func limitUser(completion: @escaping(Result<UserLimitModel, ErrorResult>) -> Void) {
        
        guard let url = URL.urlUserLimit() else {
            return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
        }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("URL ABSOLUTE : \(url.absoluteURL)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return completion(Result.failure(ErrorResult.network(string: "Bad URL")))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                
                if (httpResponse.statusCode == 200) {
                    print("ON Success")
                    print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                    
                    let userLimit = try? JSONDecoder().decode(UserLimitModel.self, from: data)
                    completion(.success(userLimit!))
                }
                
                if (httpResponse.statusCode == 401) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 404) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
                
                if (httpResponse.statusCode == 406) {
                    let response = try? JSONDecoder().decode(LoginCredentialResponse.self, from: data)
                    completion(Result.failure(ErrorResult.customWithStatus(code: httpResponse.statusCode, codeStatus: response!.code)))
                }
                
                if (httpResponse.statusCode == 403) {
                    completion(Result.failure(ErrorResult.custom(code: httpResponse.statusCode)))
                }
            }
            
        }.resume()
    }
}
