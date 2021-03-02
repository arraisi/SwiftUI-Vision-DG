//
//  FavoritViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/02/21.
//

import Foundation

class FavoritViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var favorites = [FavoritModelElement]()
    @Published var lastTransaction = [HistoryList]()
    
    @Published var errorMessage: String = ""
    
    func getListLastTransaction(sourceNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.getListLastTransaction(sourceNumber: sourceNumber) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.lastTransaction = response.historyList
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
    
    func getList(cardNo: String, sourceNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.getList(cardNo: cardNo, sourceNumber: sourceNumber) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.favorites = response
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
    
    func update(data: FavoritModelElement, name: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.update(data: data, name: name) { result in
            
            switch result {
            case .success(let status):
                print("\nVIEW MODEL STATUS UPDATE FAVORITE : \(status)\n")
                DispatchQueue.main.async {
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
    
    func updateWithParam(id: String, cardNo: String, sourceNumber: String, name: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.updateWithParam(id: id, cardNo: cardNo, sourceNumber: sourceNumber, name: name) { result in
            
            switch result {
            case .success(let status):
                print("\nVIEW MODEL STATUS UPDATE FAVORITE : \(status)\n")
                DispatchQueue.main.async {
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
    
    func remove(data: FavoritModelElement, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.remove(data: data) { result in
            
            switch result {
            case .success( _):
                
                DispatchQueue.main.async {
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
    
    func transferOnUs(data: TransferOnUsModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.save(data: data) { result in
            
            switch result {
            case .success( _):
                
                DispatchQueue.main.async {
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
    
    func transferRtgs(data: TransferOffUsModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.saveFavoriteRtgs(data: data) { result in
            
            switch result {
            case .success( _):
                
                DispatchQueue.main.async {
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
    
    func transferSkn(data: TransferOffUsModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.saveFavoriteSkn(data: data) { result in
            
            switch result {
            case .success( _):
                
                DispatchQueue.main.async {
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
