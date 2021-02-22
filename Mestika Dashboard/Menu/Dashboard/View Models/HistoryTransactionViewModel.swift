//
//  HistoryTransactionViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 19/02/21.
//

import Foundation

class HistoryTransactionViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var histories = [HistoryLists]()
    
    func getList(cardNo: String,
                 sourceNumber: String,
                 dateFrom: String,
                 dateTo: String,
                 lastRecordDate: String = "",
                 lastRecordPostingDate: String = "",
                 lastRecordTraceNo: String = "", completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        HistoryTransactionServices.shared.getList(
            cardNo: cardNo,
            sourceNumber: sourceNumber,
            dateFrom: dateFrom,
            dateTo: dateTo,
            lastRecordDate: lastRecordDate,
            lastRecordPostingDate: lastRecordPostingDate,
            lastRecordTraceNo: lastRecordTraceNo
        ) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    if let _histories = response.historyList {
                        self.histories = _histories
                    }
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR GET LIST FAVORITES-->")
                
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
