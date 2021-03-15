//
//  SavingAccountViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

class SavingAccountViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var accounts = SavingAccountModel()
    
    @Published var deposit = "0"
    @Published var destinationNumber = ""
    @Published var transactionDate = ""
    
    func getAccounts(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        SavingAccountServices.shared.getAccounts() { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.accounts = response
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR GET LIST PRODUCTS SAVING ACCOUNT-->")
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(false)
            }
            
        }
    }
    
    func saveAccount(kodePlan: String, deposit: String, pinTrx: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        SavingAccountServices.shared.saveSavingAccount(kodePlan: kodePlan, deposit: deposit, pinTrx: pinTrx) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.transactionDate = response.transactionDate
                    self.deposit = response.nominal
                    self.destinationNumber = response.destinationNumber
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR GET LIST PRODUCTS SAVING ACCOUNT-->")
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(false)
            }
            
        }
    }
    
}
