//
//  ReferenceViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 10/02/21.
//

import Foundation

class ReferenceSummaryViewModel: ObservableObject {
    var idReference: Int = 0
    
    @Published var _listBank = BankReferenceResponse()
    
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    @Published var code: String = ""
    
    // MARK:- GET ALL SCHEDULE
    func getAllSchedule(completion: @escaping (Bool) -> Void) {
        if _listBank.count > 0 {
            self.isLoading = false
            completion(true)
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ReferenceService.shared.getBankReference { [self] result in
            print(result)
            
            switch (result) {
            case .success(let response):
                print("Length Data Bank : \(response.count)")
                
                self._listBank = response
                self.isLoading = false
                completion(true)
                
            case.failure(let error):
                print("Error Get Schedule")
                self.isLoading = false
                print(error.localizedDescription)
                
                completion(false)
            }
        }
    }
}

class BankReferenceViewModel {
    
    var data: BankReferenceResponseElement
    
    init(data: BankReferenceResponseElement) {
        self.data = data
    }
    
    var swiftCode: String {
        return self.data.swiftCode
    }
    
    var kliringCode: Int {
        return self.data.kliringCode
    }
    
    var sknRtgsCode: Int {
        return self.data.sknRtgsCode
    }
    
    var combinationName: String {
        return self.data.combinationName
    }
    
    var bankName: String {
        return self.data.bankName
    }
    
    
}
