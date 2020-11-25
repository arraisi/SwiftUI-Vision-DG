//
//  CitizenViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation
import Combine

class CitizenViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var nik: String = ""
    @Published var errorMessage: String = ""
}

extension CitizenViewModel {
    
    // MARK: - GET CITIZEN
    func getCitizen(nik: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        CitizenService.shared.checkNIK(nik: nik) { result in
            switch result {
            case .success(let response):
                
                if (response.code == "00") {
                    print("Failed")
                    print(response.message)
                    
                    self.errorMessage = response.message!
                    completion(false)
                } else {
                    print("Success")
                    print(response.nik)
                    
                    self.isLoading = false
                    self.nik = response.nik ?? ""
                    self.errorMessage = "VALID"
                    completion(true)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
