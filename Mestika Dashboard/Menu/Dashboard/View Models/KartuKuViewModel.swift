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
                self.listKartuKu.removeAll()
                
                self.listKartuKu = response.map({ (data: KartuKuResponseElement) -> KartuKuDesignViewModel in
                    print(data.cardDesign!)
                    return KartuKuDesignViewModel(
                        maxIbftPerTrans: data.maxIbftPerTrans ?? "0",
                        limitOnUs: data.limitOnUs ?? "0",
                        limitWd: data.limitWd ?? "0",
                        limitPayment: data.limitPayment ?? "0",
                        limitPurchase: data.limitPurchase ?? "0",
                        limitIbft: data.limitIbft ?? "0",
                        cardFlag: data.cardFlag ?? "0",
                        kodepos: data.kodepos ?? "",
                        provinsi: data.provinsi ?? "0",
                        kabupatenKota: data.kabupatenKota ?? "0",
                        kecamatan: data.kecamatan ?? "0",
                        kelurahan: data.kelurahan ?? "0",
                        rw: data.rw ?? "0",
                        rt: data.rt ?? "0",
                        postalAddress: data.postalAddress ?? "0",
                        accountNumber: data.accountNumber ?? "0",
                        nameOnCard: data.nameOnCard ?? "0",
                        cardNo: data.cardNo ?? "",
                        cardDesign: URL(string: data.cardDesign ?? "0"),
                        classCode: data.classCode ?? "0",
                        nik: data.nik ?? "0",
                        id: data.id ?? "0",
                        imageNameAlias: data.imageNameAlias ?? "0",
                        mainCard: data.mainCard!,
                        status: data.status ?? "INACTIVE")
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
            case .success(_):
                
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
                    self.message = "PIN Transaksi Salah"
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
            case .success(_):
                
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
                    self.message = "PIN Transaksi Salah"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 406):
                    self.code = "406"
                    self.message = "PIN Transaksi Terblokir"
                case .customWithStatus(code: 406, codeStatus: "408"):
                    self.code = "408"
                    self.message = "CVV salah"
                case .customWithStatus(code: 406, codeStatus: "409"):
                    self.code = "409"
                    self.message = "CVV salah 3 kali"
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
            case .success(_):
                
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
                    self.message = "PIN Transaksi Salah"
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
            case .success(_):
                
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
                    self.message = "PIN Transaksi Salah"
                case .custom(code: 406):
                    self.code = "401"
                    self.message = "Kartu Anda Terblokir"
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
    
    // MARK: - LIMIT KARTU KU
    func updateLimitKartuKu(data: LimitKartuKuModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        KartuKuService.shared.putLimitKartuKu(data: data) { result in
            switch result {
            case .success(_ ):
                
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                self.isLoading = false
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "PIN Transaksi Salah"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "403"
                    self.message = "Pin Transaksi Salah"
                case .custom(code: 400):
                    self.code = "400"
                    self.message = "Message parametr tidak valid"
                case .custom(code: 406):
                    self.code = "406"
                    self.message = "Pin Transaksi Terblokir"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
                case .custom(code: 502):
                    self.code = "502"
                    self.message = "Gagal Update Limit"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
