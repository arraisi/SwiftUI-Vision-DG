//
//  FavoriteViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 09/02/21.
//

import Foundation

class FavoritesViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var favorites = [FavoriteModelElement]()
    
    @Published var errorMessage: String = ""
    
    func getList(cardNo: String, sourceNumber: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoriteServices.shared.getList(cardNo: cardNo, sourceNumber: sourceNumber) { result in
            
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
    
    func update(data: FavoriteModelElement, name: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoriteServices.shared.update(data: data, name: name) { result in
            
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
    
    func remove(data: FavoriteModelElement, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        FavoriteServices.shared.remove(data: data) { result in
            
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
