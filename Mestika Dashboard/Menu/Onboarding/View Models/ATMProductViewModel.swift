//
//  ATMProductViewModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 24/11/20.
//

import UIKit

class ATMProductViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var listATM: [ATMViewModel] = []
    @Published var listATMDesign: [ATMDesignViewModel] = []
}

extension ATMProductViewModel {
    // MARK: - POST Product ATM
    func addProductATM(dataRequest: AddProductATM, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.postAddProductATM(dataRequest: dataRequest) { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                if (response.status) {
                    print("Valid")
                    completion(true)
                }
                break
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    // MARK: - Get List ATM
    func getListATM(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.getListATM() { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.listATM = response.map({ (data: ATMModel) -> ATMViewModel in
                        return ATMViewModel (
                            id: data.id,
                            key: data.key,
                            title: data.title,
                            cardImage: URL(string: data.cardImage),
                            description: self.mapDescriptionLimit(data: data.description)
                        )
                    })
                    completion(true)
                }
                break
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
                print(error.localizedDescription)
            }
        }
    }
    
    func mapDescriptionLimit(data: ATMDescriptionModel) -> ATMDescriptionModel {
        return ATMDescriptionModel(limitPurchase: data.limitPurchase.thousandSeparator(),
                                   limitPayment: data.limitPayment.thousandSeparator(),
                                   limitPenarikanHarian: data.limitPenarikanHarian.thousandSeparator(),
                                   limitTransferKeBankLain: data.limitTransferKeBankLain.thousandSeparator(),
                                   limitTransferAntarSesama: data.limitTransferAntarSesama.thousandSeparator(),
                                   codeClass: data.codeClass)
    }
    
    // MARK: - Get List ATM Design
    func getListATMDesign(type: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.getListATMDesign(type: type) { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.listATMDesign = response.data.content.map({ (data: ATMDesignModel) -> ATMDesignViewModel in
                        return ATMDesignViewModel (
                            id: data.id,
                            key: data.key,
                            title: data.title,
                            cardType: data.cardType,
                            cardImage: URL(string: data.cardImage),
                            description: data.description
                        )
                    })
                    completion(true)
                }
                break
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                }
                print(error.localizedDescription)
            }
        }
    }
}
