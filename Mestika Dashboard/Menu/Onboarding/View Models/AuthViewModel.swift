//
//  AuthViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import Foundation
import Combine
import SwiftyRSA

class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var fingerprintFlag: Bool = false
    @Published var nik: String = ""
    @Published var password: String = ""
    @Published var phoneNumber: String = ""
    @Published var pinTransaction: String = ""
    @Published var status: String = ""
    @Published var errorMessage: String = ""
}

extension AuthViewModel {
    
    // MARK: - POST LOGIN
    func postLogin(
        password: String,
        phoneNumber: String,
        fingerCode: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.login(password: encryptPassword(password: password), phoneNumber: phoneNumber, fingerCode: fingerCode) { result in
            switch result {
            case .success(let response):
                print("Success")
                self.isLoading = false
                self.nik = response.nik
                self.password = response.password
                self.phoneNumber = response.phoneNumber
                self.pinTransaction = response.pinTransaction
                self.status = response.status
                self.fingerprintFlag = response.fingerprintFlag
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST LOGIN
    func postLogout(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.logout() { result in
            switch result {
            case .success(let response):
                print("Success")
                print("response \(response)")
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
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
