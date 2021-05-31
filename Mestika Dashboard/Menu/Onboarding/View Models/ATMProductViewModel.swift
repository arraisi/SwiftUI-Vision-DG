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
    @Published var listJenisATM: JenisATMModel = []
    @Published var listATMDesign: [ATMDesignViewModel] = []
    @Published var listJenisTabungan: [JenisTabunganViewModel] = []
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
    
    // MARK: - Get List Jenis Tabungan
    func getListJenisTabungan(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.getListJenisTabungan() { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.listJenisTabungan = response.map({ (data: JenisTabunganModelElement) -> JenisTabunganViewModel in
                        return JenisTabunganViewModel (
                            id: data.id ,
                            name: data.productName ,
                            image: URL(string: data.productImageURL ),
                            description: data.productDescription ,
                            type: data.balType ?? "",
                            codePlan: data.kodePlan
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
    
    func mapDescriptionLimit(data: JenisATMModelElement) -> ATMDescriptionModel {
        return ATMDescriptionModel(limitPurchase: data.limitPurchase.thousandSeparator(),
                                   limitPayment: data.limitPayment.thousandSeparator(),
                                   limitPenarikanHarian: data.limitWd.thousandSeparator(),
                                   limitTransferKeBankLain: data.limitIbft.thousandSeparator(),
                                   limitTransferAntarSesama: data.limitOnUs.thousandSeparator(),
                                   codeClass: data.classCode)
    }
    
    func getListJenisATM(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.getListJenistATM() { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.listATM = response.map({ (data: JenisATMModelElement) -> ATMViewModel in
                        let image = UIImage(named: "card_bg")!
                        return ATMViewModel (
                            id: data.classCode,
                            key: "",
                            title: data.cardName,
                            cardImage: URL(string: data.cardImageURL),
                            description: self.mapDescriptionLimit(data: data),
                            cardImageBase64: image
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
    
    // MARK: - Get List ATM Design
    func getListATMDesign(classCode: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ATMService.shared.getListATMDesign(classCode: classCode) { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.listATMDesign = response.map({ (data: DesainAtmModel) -> ATMDesignViewModel in
                        let image = UIImage(named: "card_bg")!
                        
                        return ATMDesignViewModel (
                            id: data.cardTypeName,
                            key: "",
                            title: data.cardTypeName,
                            cardType: "",
                            cardImage: URL(string: data.cardTypeImageURL),
                            description: data.cardTypeDescription,
                            cardImageBase64: image
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
