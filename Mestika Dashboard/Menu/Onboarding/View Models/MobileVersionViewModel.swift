//
//  MobileVersionViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/11/20.
//

import Foundation
import Combine

class MobileVersionViewModel: ObservableObject {
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var versionNumber: String = ""
    @Published private(set) var versionCodeMajor: String = ""
    @Published private(set) var versionCodeMinor: String = ""
    @Published private(set) var versionCodePatch: String = ""
    @Published private(set) var versionName: String = ""
    
    @Published private(set) var responseCode: String = ""
    @Published private(set) var responseMsg: String = ""
}

extension MobileVersionViewModel {
    
    func getMobileVersion(isCertificatePinning: Bool, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        MobileVersionService.shared.getVersion(isCertificatePinning: isCertificatePinning) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("ini data versi")
                    print(response.versionName)
                    self.responseMsg = "Certificate pinning is successfully completed"
                    self.isLoading = false
                    self.versionNumber = response.versionName
                    self.versionCodeMajor = response.versionCodeMajor
                    self.versionCodeMinor = response.versionCodeMinor
                    self.versionCodePatch = response.versionCodePatch
                    self.versionName = response.versionName
                    completion(true)
                }
            case .failure(let error):
                
                switch error {
                case .custom(code: 600):
                    self.isLoading = false
                    self.responseCode = "600"
                    self.responseMsg = "Failed Pinning"
                case .custom(code: 700):
                    self.isLoading = false
                    self.responseCode = "700"
                    self.responseMsg = "Certificate pinning not completed"
                default:
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                
                print(error.localizedDescription)
                completion(false)
            }
            
        }
    }
}
