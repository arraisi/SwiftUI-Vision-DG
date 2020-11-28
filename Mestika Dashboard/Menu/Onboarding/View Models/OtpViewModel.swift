//
//  OtpViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation
import Combine

class OtpViewModel: ObservableObject {
//    var destination: String = "085875074351"
    var destination: String = "08562006488"
    var type: String = "hp"
    
    @Published var isLoading: Bool = false
    @Published var reference: String = ""
    @Published var timeCounter: Int = 30
    @Published var code: String = ""
    @Published var statusMessage: String = ""
}

extension OtpViewModel {
    
    // MARK: - POST OTP
    func otpValidation(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        type: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.validateOtp(
            code: code,
            destination: destination,
            reference: reference,
            timeCounter: timeCounter,
            tryCount: tryCount,
            type: type) { result in
            
            switch result {
            case.success(let response):
                
                if (response.status?.message != "OTP_INVALID") {
                    print("Success")
                    
                    self.isLoading = false
                    completion(true)
                } else {
                    print("Failed")
                    print(response.status?.message)
                    print(response.status?.code)
                    
                    self.isLoading = false
                    completion(false)
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
    
    // MARK:- GET OTP
    func otpRequest(otpRequest: OtpRequest, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.getRequestOtp(otpRequest: otpRequest) { result in
            switch result {
            case.success(let response):
                print(response.status?.message!)
                
                if (response.status?.message != "OTP_REQUESTED_FAILED") {
                    print("Success")
                    print(response.timeCounter)
                    print(response.tryCount)

                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.destination = response.destination ?? ""
                        self.reference = response.reference ?? "0"
                        self.code = response.code ?? "0"
                        self.statusMessage = (response.status?.message)!
                        self.timeCounter = response.timeCounter ?? 30
                        
                        completion(true)
                    }

                } else {
                    print("Failed Request")
                    
                    self.isLoading = false
                    self.statusMessage = (response.status?.message)!
                    self.timeCounter = response.tryCount ?? 0
                    
                    completion(false)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.statusMessage = "Server Error"
                }
                
                completion(false)
                print(error.localizedDescription)
            }
            
        }
    }
}
