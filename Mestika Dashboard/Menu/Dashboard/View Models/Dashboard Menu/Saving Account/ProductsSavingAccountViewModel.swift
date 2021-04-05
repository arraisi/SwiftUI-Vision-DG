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
    
    @Published var products = [ProductsSavingAccountModelElement]()
    
    // PRODUCT Details
    @Published var currency: String?
    @Published var outgoing = ""
    @Published var minimumSaldo: String?
    @Published var biayaAdministrasi: String?
    @Published var minimumSetoranAwal: String?
    @Published var minimumNextDeposit: String?
    
    func getProducts(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        SavingAccountServices.shared.getProducts() { result in
            
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.products = response
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
                
                print("SUCCESS GET PRODUCTS details")
                
                DispatchQueue.main.async {
                    //                    self.productDetails = response
                    self.currency = response.currency ?? "0"
                    self.outgoing = response.outgoing ?? "0"
                    self.minimumSaldo = response.minimumSaldo ?? "0"
                    self.biayaAdministrasi = response.biayaAdministrasi ?? "0"
                    self.minimumSetoranAwal = response.minimumSetoranAwal ?? "0"
                    self.minimumNextDeposit = response.minimumSetoranSelanjutnya ?? "0"
                    
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR GET LIST PRODUCTS SAVING ACCOUNT-->")
                
                DispatchQueue.main.async {
                    
                    switch error {
                    case .custom(code: 500):
                        self.errorMessage = "Internal Server Error"
                    default:
                        self.errorMessage = "Internal Server Error"
                    }
                    
                    self.isLoading = false
                }
                
                completion(false)
            }
            
        }
    }
    
}
