//
//  EStatementViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 08/06/21.
//

import Foundation

class EStatementViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var listEStatement = EStatementModel()
}

extension EStatementViewModel {
    // MARK: - LIST KARTU KU
    func getListEStatement(accountNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        EStatementService.shared.getListEStatement(accountNumber: accountNumber) { result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("SUCCESS")
                    
                    self.listEStatement = response
                    print("LIST ESTATEMENT COUNT VM: \(self.listEStatement)")
                    
                    completion(true)
                case .failure(let error):
                    print("ERROR GET LIST ESTATEMENT KU --> \(error)")
                    
                    switch error {
                    case .custom(code: 500):
                        self.errorMessage = "Internal Server Error"
                    default:
                        self.errorMessage = "Internal Server Error"
                    }
                    
                    completion(false)
                }
                
            }
        }
    }
}
