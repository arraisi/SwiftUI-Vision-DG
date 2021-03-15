//
//  ProductsSavingAccountViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 15/03/21.
//

import Foundation

class ProductsSavingAccountViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var products = [ProductSavingAccountModel]()
    
    // PRODUCT Details
    @Published var currency = ""
    @Published var outgoing = ""
    @Published var minimumSaldo = ""
    @Published var biayaAdministrasi = ""
    @Published var minimumSetoranAwal = ""
    
    func getProducts(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        SavingAccountServices.shared.getProducts() { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.products = response.content
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
    
    func getProductsDetails(planCode: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        SavingAccountServices.shared.getProductDetails(planCode: planCode) { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
//                    self.productDetails = response
                    self.currency = response.currency
                    self.outgoing = response.outgoing
                    self.minimumSaldo = response.minimumSaldo
                    self.biayaAdministrasi = response.biayaAdministrasi
                    self.minimumSetoranAwal = response.minimumSetoranAwal
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
