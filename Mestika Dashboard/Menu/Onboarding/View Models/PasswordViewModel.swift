//
//  PasswordViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 28/11/20.
//

import Foundation
import Combine
import SwiftyRSA

class PasswordViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var code: String = ""
    @Published private(set) var message: String = ""
}

extension PasswordViewModel {
    
    /* PASSWORD VALIDATION */
    func validationPassword(password: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        PasswordService.shared.getValidationPassword(password: encryptPassword(password: password)) { result in
            switch result {
            case .success(let response):
                print(response.code)
                DispatchQueue.main.async {
                    self.code = response.code
                    self.message = response.message
                    completion(true)
                }
                
            case .failure(_):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
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
