//
//  ProfileViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/02/21.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    @Published var name: String = ""
    @Published var balance: String = ""
    @Published var nameOnCard: String = ""
    @Published var telepon: String = ""
    
    @Published var cardNo: String = ""
    @Published var cardName: String = ""
    
    @Published var errorMessage: String = ""
}

extension ProfileViewModel {
    
    // MARK: - GET PROFILE
    func getProfile(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.checkProfile { result in
            switch result {
            case .success(let response):
                print("Success")
                self.isLoading = false
                
                self.name = response.personal.name
                self.telepon = response.profileResponseModelID.telepon
                self.nameOnCard = response.products.last!.productName
                self.balance = response.chipProfileDto.last!.balance
                
                self.cardName = response.chipProfileDto.last!.nameOnCard
                self.cardNo = response.chipProfileDto.last!.cardNo
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.errorMessage = "USER STATUS NOT FOUND"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
