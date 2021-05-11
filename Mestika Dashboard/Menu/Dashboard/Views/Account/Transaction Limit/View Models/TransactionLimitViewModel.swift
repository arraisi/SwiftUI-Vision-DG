//
//  TransactionLimitViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/05/21.
//

import Foundation
import SwiftyRSA

class TransactionLimitViewModel: ObservableObject {
    @Published var maxTrxOnCifIdr: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxOnCifNonIdr: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxOnUsIdr: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxOnUsNonIdr: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxVirtualAccount: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxSknTransfer: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxRtgsTransfer: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxRtgsTransferTxt: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxOnlineTransfer: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxBillPayment: Double = Double.greatestFiniteMagnitude
    @Published var maxTrxPurchase: Double = Double.greatestFiniteMagnitude
    
    @Published var trxOnCifIdr: Double = 10000
    @Published var trxOnCifNonIdr: Double = 10000
    @Published var trxOnUsIdr: Double = 100000
    @Published var trxOnUsNonIdr: Double = 10000
    @Published var trxVirtualAccount: Double = 10000
    @Published var trxSknTransfer: Double = 10000
    @Published var trxRtgsTransfer: Double = 10000
    @Published var trxOnlineTransfer: Double = 10000
    @Published var trxBillPayment: Double = 10000
    @Published var trxPurchase: Double = 10000
    
    @Published var nik: String = ""
}

extension TransactionLimitViewModel {
    func mappingGlobalLimitData(data: GlobalLimitModel) {
        data.forEach { (limit) in
            switch limit.key {
            case "trxOnCifIdr":
                self.maxTrxOnCifIdr = Double(limit.value)
            case "trxOnCifNonIdr":
                self.maxTrxOnCifNonIdr = Double(limit.value)
            case "trxOnUsIdr":
                self.maxTrxOnUsIdr = Double(limit.value)
            case "trxOnUsNonIdr":
                self.maxTrxOnUsNonIdr = Double(limit.value)
            case "trxVirtualAccount":
                self.maxTrxVirtualAccount = Double(limit.value)
            case "trxSknTransfer":
                self.maxTrxSknTransfer = Double(limit.value)
            case "trxRtgsTransfer":
                self.maxTrxRtgsTransfer = Double(limit.value)
            case "trxOnlineTransfer":
                self.maxTrxOnlineTransfer = Double(limit.value)
            case "trxBillPayment":
                self.maxTrxBillPayment = Double(limit.value)
            case "trxPurchase":
                self.maxTrxPurchase = Double(limit.value)
            default:
                print("Have you done something new?")
            }
        }
    }
    
    func mappingUserLimitData(data: UserLimitModel) {
        
        self.nik = data.nik
        
        data.limits.forEach { (limit) in
            switch limit.key {
            case "trxOnCifIdr":
                self.trxOnCifIdr = Double(limit.value)
            case "trxOnCifNonIdr":
                self.trxOnCifNonIdr = Double(limit.value)
            case "trxOnUsIdr":
                self.trxOnUsIdr = Double(limit.value)
            case "trxOnUsNonIdr":
                self.trxOnUsNonIdr = Double(limit.value)
            case "trxVirtualAccount":
                self.trxVirtualAccount = Double(limit.value)
            case "trxSknTransfer":
                self.trxSknTransfer = Double(limit.value)
            case "trxRtgsTransfer":
                self.trxRtgsTransfer = Double(limit.value)
            case "trxOnlineTransfer":
                self.trxOnlineTransfer = Double(limit.value)
            case "trxBillPayment":
                self.trxBillPayment = Double(limit.value)
            case "trxPurchase":
                self.trxPurchase = Double(limit.value)
            default:
                print("Have you done something new?")
            }
        }
    }
}

// MARK: Servives
extension TransactionLimitViewModel {
    func findTrxGlobalLimit() {
        
        // MARK: URL
        guard let url = URL.urlGlobalLimit() else { return }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET GLOBAL LIMIT RESULT CODE : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {return}
                
                let response = try? JSONDecoder().decode(GlobalLimitModel.self, from: data)
                
                if let data = response {
                    self.mappingGlobalLimitData(data: data)
                }
                
            }
            
            
        }.resume()
    }
    
    func findTrxUserLimit() {
        
        // MARK: URL
        guard let url = URL.urlUserLimit() else { return }
        
        var request = URLRequest(url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nGET GLOBAL LIMIT RESULT CODE : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {return}
                
                let response = try? JSONDecoder().decode(UserLimitModel.self, from: data)
                
                if let data = response {
                    self.mappingUserLimitData(data: data)
                }
                
            }
            
            
        }.resume()
    }
    
    func saveTrxUserLimit(pin: String, completion: @escaping(Result<Bool, ErrorResult>) -> Void) {
        
        // MARK: BODY
        let body: [String: Any] = [
            "pinTrx" : encryptPassword(password: pin),
            "limits" : [
                ["key": "trxOnCifIdr", "value": self.trxOnCifIdr],
                ["key": "trxOnCifNonIdr", "value": self.trxOnCifNonIdr],
                ["key": "trxOnUsIdr", "value": self.trxOnUsIdr],
                ["key": "trxOnUsNonIdr", "value": self.trxOnUsNonIdr],
                ["key": "trxVirtualAccount", "value": self.trxVirtualAccount],
                ["key": "trxSknTransfer", "value": self.trxSknTransfer],
                ["key": "trxRtgsTransfer", "value": self.trxRtgsTransfer],
                ["key": "trxOnlineTransfer", "value": self.trxOnlineTransfer],
                ["key": "trxBillPayment", "value": self.trxBillPayment],
                ["key": "trxPurchase", "value": self.trxPurchase]
            ]
        ]
        
        
        print("\nbody => \(body)\n")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        print(jsonString ?? "")
        
        if JSONSerialization.isValidJSONObject(jsonData ?? "") {
            print("Valid Json")
        } else {
            print("InValid Json")
        }
        
        // MARK: URL
        guard let url = URL.urlUserLimit() else { return }
        
        var request = URLRequest(url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // MARK: TASK
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                print("\n\nSAVE USER LIMIT RESULT CODE : \(httpResponse.statusCode)")
                
                guard let data = data, error == nil else {return}
                
                let response = try? JSONDecoder().decode(Status.self, from: data)
                
                if let data = response {
                    print("RESPONSE SAVE USER LIMIT \(data)")
                    if data.code == "200" {
                        completion(.success(true))
                    }
                }
                
                completion(.failure(ErrorResult.custom(code: Int(response?.code ?? "0") ?? 0)))
            }
            
        }.resume()
    }
    
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
}
