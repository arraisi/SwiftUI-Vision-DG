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
    
}
