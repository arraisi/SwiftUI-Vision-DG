//
//  PinNoAtmViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/01/21.
//

import Foundation
import Combine
import SwiftyRSA

class PinNoAtmViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var pin: String = ""
    @Published var cardNo: String = ""
    @Published var code: String = ""
    @Published var statusMessage: String = ""
}

extension PinNoAtmViewModel {
    
    // MARK: - PIN VALIDATION
    func pinValidation (
        pin: String,
        cardNo: String,
        validateType: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        PinNoAtmService.shared.validatePin(
            pin: pin,
            cardNo: cardNo,
            validateType: validateType) { result in
            
            switch result {
            case.success(let response):
                
                print("VALIDATE PIN response.status?.message : \(response.message ?? "no message")")
                print("VALIDATE PIN response.status?.code : \(response.code ?? "no CODE")")
                
                if (response.message == "OK" || response.code == "200") {
                    print("Success")
                    self.isLoading = false
                    completion(true)
                } else {
                    print("Failed")
                    
                    DispatchQueue.main.async {
                        // self.timeRemaining = response.timeCounter!
                        self.isLoading = false
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - PIN VALIDATION NASABAH EXISTING
    func pinValidationNasabahExisting (
        atmData: AddProductATM,
        pin: String,
        cardNo: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        PinNoAtmService.shared.validatePinNasabahExisting(
            atmData: atmData,
            pin: encryptPassword(password: pin),
            cardNo: cardNo) { result in
            
            switch result {
            case.success(let response):
                
                print("VALIDATE PIN response.status?.message : \(response.message ?? "no message")")
                print("VALIDATE PIN response.status?.code : \(response.code ?? "no CODE")")
                
                if (response.message == "OK" || response.code == "200") {
                    print("Success")
                    self.isLoading = false
                    completion(true)
                } else {
                    print("Failed")
                    
                    DispatchQueue.main.async {
                        // self.timeRemaining = response.timeCounter!
                        self.isLoading = false
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(false)
                print(error.localizedDescription)
            }
        }
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
