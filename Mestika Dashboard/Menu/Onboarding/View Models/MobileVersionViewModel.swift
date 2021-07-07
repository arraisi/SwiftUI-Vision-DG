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
}

extension MobileVersionViewModel {
    
    func getMobileVersion(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        MobileVersionService.shared.getVersion() { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("ini data versi")
                    print(response.versionName)
                    self.isLoading = false
                    self.versionNumber = response.versionName
                    self.versionCodeMajor = response.versionCodeMajor
                    self.versionCodeMinor = response.versionCodeMinor
                    self.versionCodePatch = response.versionCodePatch
                    self.versionName = response.versionName
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
                completion(false)
            }
            
        }
    }
}
