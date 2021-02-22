//
//  KartuKuViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/02/21.
//

import Foundation

class KartuKuViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var kartuKu = KartuKuResponse()
    @Published var listKartuKu: [KartuKuDesignViewModel] = []
}

extension KartuKuViewModel {
    
    // MARK: - LIST KARTU KU
    func getListKartuKu(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.getListKartuKu { result in
            switch result {
            case .success(let response):
                print("SUCCESS")
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.listKartuKu = response.map({ (data: KartuKuResponseElement) -> KartuKuDesignViewModel in
                        return KartuKuDesignViewModel(
                            maxIbftPerTrans: data.maxIbftPerTrans,
                            limitOnUs: data.limitOnUs,
                            limitWd: data.limitWd,
                            limitPayment: data.limitPayment,
                            limitPurchase: data.limitPurchase,
                            limitIbft: data.limitIbft,
                            cardFlag: data.cardFlag,
                            kodepos: data.kodepos,
                            provinsi: data.provinsi,
                            kabupatenKota: data.kabupatenKota,
                            kecamatan: data.kecamatan,
                            kelurahan: data.kelurahan,
                            rw: data.rw,
                            rt: data.rt,
                            postalAddress: data.postalAddress,
                            accountNumber: data.accountNumber,
                            nameOnCard: data.nameOnCard,
                            cardNo: data.cardNo,
                            cardDesign: data.cardDesign,
                            classCode: data.classCode,
                            nik: data.nik,
                            id: data.id,
                            imageNameAlias: data.imageNameAlias,
                            balance: data.balance,
                            status: data.status,
                            mainCard: data.mainCard)
                    })
                }
                
                print(self.listKartuKu.count)
                
                completion(true)
            case .failure(let error):
                print("ERROR GET LIST KARTU KU -->")
                
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
