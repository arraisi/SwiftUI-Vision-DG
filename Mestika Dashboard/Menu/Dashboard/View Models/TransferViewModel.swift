//
//  TransferViewModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 03/02/21.
//

import Foundation

class TransferViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var timeStart: String = ""
    @Published var timeEnd: String = ""
    @Published var message: String = ""
    @Published var code: String = ""
    @Published var limitOnUs: String = ""
    @Published var limitIbft: String = ""
    
    @Published var destinationName: String = ""
    @Published var destinationNumber: String = ""
    @Published var reffNumber: String = ""
    
    @Published var status: String = ""
    
    @Published var transactionDate: String = ""
    
    // MARK: - GET LIMIT TRANSACTION
    func getLimitTransaction(classCode: String,
                             completion: @escaping (Bool) -> Void) {
        
        TransferServices.shared.getLimitTransaction(classCode: classCode) { result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.limitIbft = response.limitIbft
                    self.limitOnUs = response.limitOnUs
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                DispatchQueue.main.async {
                    switch error {
                    case .custom(code: 401):
                        self.code = "401"
                        self.message = "PIN Transaksi Salah"
                    case .custom(code: 404):
                        self.code = "404"
                        self.message = "Data tidak ditemukan"
                    case .custom(code: 403):
                        self.code = "403"
                        self.message = "Transfer Gagal"
                    default:
                        self.message = "Internal Server Error"
                    }
                }
                
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer ONUS INQUIRY
    func transferOnUsInquiry(transferData: TransferOnUsModel,
                             completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferOnUsInquiry(transferData: transferData) { result in
            print(result)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
            
            switch result {
            case .success(let response):
                print(response)
                
                DispatchQueue.main.async {
                    self.destinationName = response.destinationAccountName
                    self.reffNumber = response.ref
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "PIN Transaksi Salah"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer IBFT INQUIRY
    func transferIbftInquiry(transferData: TransferOffUsModel,
                             completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferIbftInquiry(transferData: transferData) { result in
            print(result)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isLoading = false
            }
            
            switch result {
            case .success(let response):
                print(response)
                
                DispatchQueue.main.async {
                    self.status = response.status.code
                    self.destinationName = response.destinationAccountName
                    self.destinationNumber = response.destinationAccountNumber
                    self.reffNumber = response.reffNumber
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                print(error)
                
                switch error {
                case .custom(code: 401):
                    self.code = "401"
                    self.message = "PIN Transaksi Salah"
                case .custom(code: 404):
                    self.code = "404"
                    self.message = "Data tidak ditemukan"
                case .custom(code: 403):
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer ONUS
    func transferOnUs(transferData: TransferOnUsModel,
                      completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferOnUs(transferData: transferData) {result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.transactionDate = response.transactionDate
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
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer IBFT
    func transferIbft(transferData: TransferOffUsModel,
                      completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferIbft(transferData: transferData) { result in
            print(result)
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.transactionDate = response.transactionDate
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
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer RTGS
    func transferRtgs(transferData: TransferOffUsModel,
                      completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferRtgs(transferData: transferData) { result in
            print(result)
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.transactionDate = response.transactionDate
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
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer SKN
    func transferSkn(transferData: TransferOffUsModel,
                     completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferSkn(transferData: transferData) { result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    self.transactionDate = response.transactionDate
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
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - Transfer ONUS
    func moveBalance(transferData: MoveBalancesModel,
                      completion: @escaping (Bool) -> Void) {
        TransferServices.shared.moveBalance(transferData: transferData) {result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.transactionDate = response.transactionDate
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
                    self.code = "403"
                    self.message = "Transfer Gagal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
