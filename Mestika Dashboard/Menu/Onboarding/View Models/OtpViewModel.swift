//
//  OtpViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation
import Combine

class OtpViewModel: ObservableObject {
    var destination: String = "85359117336"
    var type: String = "hp"
    
    @Published var isLoading: Bool = false
    @Published var reference: String = ""
    @Published var timeCounter: Int = 30
    @Published var timeRemaining: Int = 0
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
                 
                    print(response.code ?? "no code")
                    print(response.message ?? "no message")
                    
                    DispatchQueue.main.async {
                        self.timeRemaining = response.timeCounter!
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
    
    // MARK:- GET OTP
    func otpRequest(otpRequest: OtpRequest, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.getRequestOtp(otpRequest: otpRequest) { result in
            switch result {
            case.success(let response):
                print(response.status?.message! ?? "no message")
                
                if (response.status?.message != "OTP_REQUESTED_FAILED") {
                    print("Success")
                    print(response.timeCounter ?? "no timeCounter")
                    print(response.tryCount ?? "no tryCount")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.destination = response.destination ?? ""
                        self.reference = response.reference ?? "0"
                        self.code = response.code ?? "0"
                        
                        print(response.code ?? "no code")
                        print(response.message ?? "no message")
                        
                        self.statusMessage = response.status?.message ?? ""
                        self.timeCounter = response.timeCounter ?? 30
                        
                        completion(true)
                    }
                    
                } else {
                    print("Failed Request")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.statusMessage = (response.status?.message)!
                        self.timeCounter = response.tryCount ?? 0
                    }
                    
                    completion(false)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch error {
                    case .custom(code: 403):
                        self.statusMessage = "Phone Number Registered"
                    default:
                        self.statusMessage = "Internal Server Error"
                    }
                }
                completion(false)
            }
            
        }
    }
    
    // MARK: - POST OTP FOR ACC OR REKENING
    func otpValidationAccOrRek(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        type: String,
        accValue: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.validateOtpAccOrRek(
            code: code,
            destination: destination,
            reference: reference,
            timeCounter: timeCounter,
            tryCount: tryCount,
            type: type,
            accValue: accValue) { result in
            
            switch result {
            case.success(let response):
                
                if (response.status?.message != "OTP_INVALID") {
                    print("Success")
                    
                    self.isLoading = false
                    completion(true)
                } else {
                    print("Failed")
                    print(response.code ?? "no code")
                    print(response.message ?? "no message")
                    
                    
                    self.timeRemaining = response.timeCounter!
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
    
    // MARK:- GET OTP FOR ACC OR REKENING
    func otpRequestAccOrRek(otpRequest: OtpRequest, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.getRequestOtpAccOrRek(otpRequest: otpRequest) { result in
            switch result {
            case.success(let response):
                print(response.status?.message! ?? "no message")
                
                if (response.status?.message != "OTP_REQUESTED_FAILED") {
                    print("Success")
                    print(response.timeCounter ?? "no timeCounter")
                    print(response.tryCount ?? "no tryCount")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.destination = response.destination ?? ""
                        self.reference = response.reference ?? "0"
                        self.code = response.code ?? "0"
                        self.statusMessage = response.status?.message ?? ""
                        self.timeCounter = response.timeCounter ?? 30
                        
                        completion(true)
                    }
                    
                } else {
                    print("Failed Request")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.statusMessage = (response.status?.message)!
                        self.timeCounter = response.tryCount ?? 0
                    }
                    
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
    
    // MARK:- GET OTP FOR LOGIN
    func otpRequestLogin(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.getRequestOtpLogin() { result in
            switch result {
            case.success(let response):
                print(response.status?.message! ?? "no message")
                
                if (response.status?.message != "OTP_REQUESTED_FAILED") {
                    print("Success")
                    print(response.timeCounter ?? "no timeCounter")
                    print(response.tryCount ?? "no tryCount")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.destination = response.destination ?? ""
                        self.reference = response.reference ?? "0"
                        self.code = response.code ?? "0"
                        
                        print(response.code ?? "no code")
                        print(response.message ?? "no message")
                        
                        self.statusMessage = response.status?.message ?? ""
                        self.timeCounter = response.timeCounter ?? 30
                        
                        completion(true)
                    }
                    
                } else {
                    print("Failed Request")
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.statusMessage = (response.status?.message)!
                        self.timeCounter = response.tryCount ?? 0
                    }
                    
                    completion(false)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch error {
                    case .custom(code: 403):
                        self.statusMessage = "Phone Number Registered"
                    case .custom(code: 404):
                        self.statusMessage = "USER_STATUS_NOT_FOUND"
                    default:
                        self.statusMessage = "Internal Server Error"
                    }
                }
                completion(false)
            }
            
        }
    }
    
    // MARK: - POST OTP FOR LOGIN
    func otpValidationLogin(
        code: String,
        destination: String,
        reference: String,
        timeCounter: Int,
        tryCount: Int,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        OtpService.shared.validateOtpLogin(
            code: code,
            destination: destination,
            reference: reference,
            timeCounter: timeCounter,
            tryCount: tryCount) { result in
            
            switch result {
            case.success(let response):
                
                if (response.status?.message != "OTP_INVALID") {
                    print("Success")
                    
                    self.isLoading = false
                    completion(true)
                } else {
                    print("Failed")
                    print(response.code ?? "no code")
                    print(response.message ?? "no message")
                    
                    DispatchQueue.main.async {
                        self.timeRemaining = response.timeCounter!
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
}
