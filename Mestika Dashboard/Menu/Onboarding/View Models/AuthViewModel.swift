//
//  AuthViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import Foundation
import Combine

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
        
        AuthService.shared.login(password: password, phoneNumber: phoneNumber, fingerCode: fingerCode) { result in
            switch result {
            case .success(let response):
                print("Success")
                self.isLoading = false
                self.nik = response.nik ?? ""
                self.password = response.password ?? ""
                self.phoneNumber = response.phoneNumber ?? ""
                self.pinTransaction = response.pinTransaction ?? ""
                self.status = response.status ?? ""
                self.fingerprintFlag = response.fingerprintFlag ?? false
                
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
}
