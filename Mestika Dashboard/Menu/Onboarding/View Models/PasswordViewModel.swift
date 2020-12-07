//
//  PasswordViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 28/11/20.
//

import Foundation
import Combine

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
        
        PasswordService.shared.getValidationPassword(password: password) { result in
            switch result {
            case .success(let response):
                print(response.code)
                DispatchQueue.main.async {
                    self.code = response.code
                    self.message = response.message
                    completion(true)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
            }
        }
    }
}
