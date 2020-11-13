//
//  OtpViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation
import Combine

class OtpViewModel: ObservableObject {
    var destination: String = "085875074351"
    var type: String = "hp"
    
    @Published var isLoading: Bool = false
    @Published var reference: String = ""
    @Published var timeCounter: Int = 15
    @Published var code: String = ""
    @Published var errorMessage = ErrorResponse()
}

extension OtpViewModel {
    
    // MARK: - POST OTP
    func otpValidation(otpRequest: OtpResponse, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.postOtp(otpRequest: otpRequest) { result in
            switch result {
            case.success(let response):
                if (response.status != nil) {
                    print("Valid")
                    
                    
                }
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK:- GET OTP
    func otpRequest(otpRequest: OtpRequest, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.getRequestOtp(otpRequest: otpRequest) { result in
            switch result {
            case.success(let response):
                if (response.code != nil) {
                    print("Success")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.reference = response.reference!
                        self.code = response.code!
                    }
                    
                    completion(true)
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    completion(true)
                }
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
            }
            
        }
    }
}
