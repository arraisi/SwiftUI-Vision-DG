//
//  OtpViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/11/20.
//

import Foundation

class OtpViewModel: ObservableObject {
    var destination: String = ""
    var type: String = "hp"
    
    @Published var isLoading: Bool = false
    @Published var reference: String = ""
    @Published var timeCounter: Int = 15
    @Published var code: String = ""
}

extension OtpViewModel {
    
    func otpRequest(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let otpReq = OtpRequest(destination: destination, type: type)
        
        OtpService.shared.getRequestOtp(otpRequest: otpReq) { result in
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
