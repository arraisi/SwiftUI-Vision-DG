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
    
    // Account Balance
    @Published var creditDebit: String = ""
    
    // Limit
    @Published var maxIbftPerTrans: String = ""
    @Published var limitOnUs: String = ""
    @Published var limitWd: String = ""
    @Published var limitPayment: String = ""
    @Published var limitPurchase: String = ""
    @Published var limitIbft: String = ""
    
    @Published var name: String = ""
    @Published var balance: String = ""
    @Published var nameOnCard: String = ""
    @Published var telepon: String = ""
    @Published var email: String = ""
    
    @Published var classCode: String = ""
    @Published var cardNo: String = ""
    @Published var cardName: String = ""
    @Published var accountNumber: String = ""
    @Published var productName: String = ""
    
    // Address
    @Published var alamat: String = ""
    @Published var provinsiName: String = ""
    @Published var kabupatenName: String = ""
    @Published var kecamatanName: String = ""
    @Published var kelurahanName: String = ""
    @Published var rt: String = ""
    @Published var rw: String = ""
    
    @Published var errorMessage: String = ""
    @Published var statusCode: String = ""
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
                self.classCode = response.chipProfileDto?.last?.classCode ?? ""
                
                self.maxIbftPerTrans = response.chipProfileDto?.last?.maxIbftPerTrans ?? "0"
                self.limitOnUs = response.chipProfileDto?.last?.limitOnUs ?? "1000000"
                self.limitWd = response.chipProfileDto?.last?.limitWd ?? "0"
                self.limitPayment = response.chipProfileDto?.last?.limitPayment ?? "0"
                self.limitPurchase = response.chipProfileDto?.last?.limitPurchase ?? "0"
                self.limitIbft = response.chipProfileDto?.last?.limitIbft ?? "0"
                
                if let _chipProfileDto = response.chipProfileDto?.last {
                    self.cardName = _chipProfileDto.nameOnCard
                    self.cardNo = _chipProfileDto.cardNo ?? ""
                    self.accountNumber = _chipProfileDto.accountNumber
                    print(_chipProfileDto.accountNumber)
                }
                 
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.statusCode = "404"
                    self.errorMessage = "USER STATUS NOT FOUND"
                case .custom(code: 401):
                    self.statusCode = "401"
                    self.errorMessage = "LOGEDOUT"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - GET ACCOUNT BALANCE
    func getAccountBalance(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.getAccountBalance { result in
            switch result {
            case .success(let response):
                print("Success")
                
                self.isLoading = false
                
                if (response.balance == "") {
                    self.balance = "0"
                } else {
                    self.balance = response.balance ?? "0"
                }
    
                self.creditDebit = response.creditDebit
                 
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
