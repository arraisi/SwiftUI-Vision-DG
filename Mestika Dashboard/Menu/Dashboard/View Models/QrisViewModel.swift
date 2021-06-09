//
//  QrisViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/04/21.
//

import Foundation

class QrisViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    @Published var code: String = ""
    
    
//    Parse Qris
    @Published var transactionCurrency: String = ""
    @Published var transactionFee: String = ""
    @Published var merchantCity: String = ""
    @Published var transactionAmount: String = ""
    @Published var merchantName: String = ""
    
//    Pay Qris
    @Published var pan: String = ""
    @Published var fromAccountName: String = ""
    @Published var fromAccount: String = ""
    @Published var transactionDate: String = ""
    @Published var reffNumber: String = ""
    @Published var responseCode: String = ""
    
    // MARK: - PARSE QRIS
    func parseQris(data: QrisModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        QrisService.shared.parseQris(qrisData: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                self.transactionCurrency = response.currency
                self.transactionFee = response.transactionFee
                self.merchantCity = response.merchantCity
                self.transactionAmount = response.transactionAmount
                self.merchantName = response.merchantName
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                DispatchQueue.main.async {
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
    
    // MARK: - PAY QRIS
    func payQris(data: QrisModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        QrisService.shared.payQris(qrisData: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                self.pan = response.pan ?? ""
                self.fromAccount = response.fromAccount ?? ""
                self.transactionDate = response.transactionDate ?? ""
                self.reffNumber = response.invoiceNumber ?? ""
                self.responseCode = response.responseCode ?? ""
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                DispatchQueue.main.async {
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
                case .custom(code: 406):
                    self.code = "406"
                    self.message = "PIN Transaksi Terblokir"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - STATUS QRIS
    func statusQris(data: QrisModel, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        QrisService.shared.checkStatusQris(qrisData: data) { result in
            switch result {
            case .success(let response):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                self.pan = response.pan ?? ""
                self.fromAccount = response.fromAccount ?? ""
                self.transactionDate = response.transactionDate ?? ""
                self.reffNumber = response.invoiceNumber ?? ""
                self.responseCode = response.responseCode ?? ""
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                DispatchQueue.main.async {
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
