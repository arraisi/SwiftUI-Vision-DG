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
    
    @Published var message: String = ""
    @Published var code: String = ""
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
                
                self.isLoading = false
                
                self.listKartuKu = response.map({ (data: KartuKuResponseElement) -> KartuKuDesignViewModel in
                    print(data.cardDesign)
                    return KartuKuDesignViewModel(
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
                        cardNo: data.cardNo ?? "",
                        cardDesign: URL(string: data.cardDesign),
                        classCode: data.classCode,
                        nik: data.nik,
                        id: data.id,
                        imageNameAlias: data.imageNameAlias,
                        mainCard: data.mainCard!,
                        status: data.status ?? "")
                })
                
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
    
    // MARK: - ACTIVATE KARTU KU
    func changePinKartuKu(cardNo: String, pin: String, newPin: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.postChangePinKartKu(cardNo: cardNo, pin: pin, newPin: newPin) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "Invalid Pin Trx"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "400"
                    self.message = "Message parametr tidak valid"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - ACTIVATE KARTU KU
    func activateKartuKu(data: ActivateKartuKuModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.postActivateKartKu(data: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "Invalid Pin Trx"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "400"
                    self.message = "Message parametr tidak valid"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - BROKEN KARTU KU
    func brokenKartuKu(data: BrokenKartuKuModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.postBrokenKartKu(data: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "Invalid Pin Trx"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "400"
                    self.message = "Message parametr tidak valid"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - BLOCK KARTU KU
    func blockKartuKu(data: BrokenKartuKuModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.postBlockKartKu(data: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "Invalid Pin Trx"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "400"
                    self.message = "Message parametr tidak valid"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
