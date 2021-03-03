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
    
    func getListFavoriteFilterType(type: String, cardNo: String, sourceNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.getList(cardNo: cardNo, sourceNumber: sourceNumber) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
//                    self.favorites = response
                    
                    self.favorites = response.filter({ (data: FavoritModelElement) -> Bool in
                        if (type.isEmpty) {
                            self.favorites = response
                           return true
                        }
                        
                        print(type)
                        
                        if (type == "Mestika") {
                            print("SESAMA")
                            print(type)
                            return data.type == "TRANSFER_SESAMA"
                        } else if (type == "All") {
                            print("All")
                            self.favorites = response
                           return true
                        } else if (type == "SKN" || data.type == "RTGS") {
                            print("RTGS or SKN")
                            print(type)
                            return data.type == "ke Bank Lain"
                        } else {
                            print("Online")
                            print(type)
                            return data.type == "Online"
                        }
                        
//                        return data.name.lowercased() == searchText.lowercased()
                    })
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
    
    func getListFavoriteFilter(searchText: String, cardNo: String, sourceNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoritService.shared.getList(cardNo: cardNo, sourceNumber: sourceNumber) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
//                    self.favorites = response
                    
                    self.favorites = response.filter({ (data: FavoritModelElement) -> Bool in
                        if (searchText.isEmpty) {
                            self.favorites = response
                           return true
                        }
                        
                        if (data.type == "TRANSFER_SESAMA") {
                            print("SESAMA")
                            print(searchText)
                            return data.name.lowercased() == searchText.lowercased() || data.transferOnUs!.destinationNumber == searchText
                        } else {
                            
                            if (data.transferOffUsRtgs == nil) {
                                print("SKN")
                                print(searchText)
                                return data.name.lowercased() == searchText.lowercased() || data.transferOffUsSkn!.accountTo == searchText
                            } else {
                                print("RTGS")
                                print(searchText)
                                return data.name.lowercased() == searchText.lowercased() || data.transferOffUsRtgs!.accountTo == searchText
                            }
                            
                        }
                        
//                        return data.name.lowercased() == searchText.lowercased()
                    })
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
