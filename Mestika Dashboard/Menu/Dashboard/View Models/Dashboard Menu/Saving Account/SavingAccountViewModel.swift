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
    @Published var errorCode: String = ""
    
    @Published var accounts = SavingAccountModel()
    @Published var savingAccounts = SavingAccountTransferResponse()
    
    @Published var balanceAccount = AccountBalanceListResponse()
    
    @Published var deposit = "0"
    @Published var destinationNumber = ""
    @Published var transactionDate = ""
    
    func getBalanceAccounts(listSourceNumber: [String], completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        self.balanceAccount.removeAll()
        
        SavingAccountServices.shared.getListAccountBalance(listSourceNumber: listSourceNumber) { result in
            
            switch result {
            case .success(let response):
                
                print("COUNT")
                print(response.count)
                
                self.balanceAccount = response
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR GET LIST BALANCE ACCOUNT-->")
                
                switch error {
                case .custom(code: 401):
                    self.errorCode = "401"
                    self.errorMessage = "LOGGEDOUT"
                case .custom(code: 500):
                    self.errorCode = "500"
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
    
    func getSavingAccountTransfer(data: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.accounts.removeAll()
        }
        
        SavingAccountServices.shared.getSavingAccountTransfer(data: data) { result in
            switch result {
            case .success(let response):
                
                self.savingAccounts = response
                
                DispatchQueue.main.async {
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
    
    func getAccounts(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.accounts.removeAll()
        }
        
        SavingAccountServices.shared.getAccounts() { result in
            switch result {
            case .success(let response):
                
                self.accounts = response.sorted(by: { $0.categoryProduct?.lowercased() ?? "" > $1.categoryProduct?.lowercased() ?? "" })
                
                DispatchQueue.main.async {
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
    
    func getAccountsAndBalance(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.accounts.removeAll()
        }
        
        SavingAccountServices.shared.getAccounts() { result in
            switch result {
            case .success(let response):
                
                self.accounts = response
                
                DispatchQueue.main.async {
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
                case .custom(code: 406):
                    self.errorCode = "406"
                    self.errorMessage = "PIN Transaksi Terblokir"
                case .custom(code: 403):
                    self.errorCode = "403"
                    self.errorMessage = "Card Blocked"
                case .custom(code: 206):
                    self.errorCode = "206"
                    self.errorMessage = "Failed Deposit"
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
