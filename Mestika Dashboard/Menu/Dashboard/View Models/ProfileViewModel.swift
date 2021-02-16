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
    @Published var email: String = ""
    
    @Published var cardNo: String = ""
    @Published var cardName: String = ""
    @Published var accountNumber: String = ""
    
    // Address
    @Published var alamat: String = ""
    @Published var provinsiName: String = ""
    @Published var kabupatenName: String = ""
    @Published var kecamatanName: String = ""
    @Published var kelurahanName: String = ""
    @Published var rt: String = ""
    @Published var rw: String = ""
    
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
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.alamat = response.personal.address
                    self.provinsiName = response.personal.propName
                    self.kabupatenName = response.personal.kabName
                    self.kecamatanName = response.personal.kecName
                    self.kelurahanName = response.personal.kelName
                    self.rt = response.personal.rt
                    self.rw = response.personal.rw
                }
                
                print("\n\nVM PROFILE \(response.personal.name)\n\n")
                print("\n\nVM PROFILE \(String(describing: response.chipProfileDto?.last!.cardNo))\n\n")
                self.name = response.personal.name
                self.telepon = response.profileResponseModelID.telepon
                self.email = response.profileResponseModelID.surel
                self.nameOnCard = response.products.last!.productName ?? ""
                self.balance = response.chipProfileDto?.last!.balance ?? "0"
                
                self.cardName = response.chipProfileDto?.last!.nameOnCard ?? ""
                self.cardNo = response.chipProfileDto?.last!.cardNo ?? ""
                self.accountNumber = response.chipProfileDto?.last!.accountNumber ?? ""
                
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
