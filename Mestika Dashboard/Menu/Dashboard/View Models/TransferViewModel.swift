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
    @Published var totalTrx: String = ""
    
    @Published var limitIbftPerTrx: String = ""
    @Published var limitPenarikanHarian: String = ""
    @Published var limitPembayaran: String = ""
    @Published var limitPembelian: String = ""
    @Published var limitOnUs: String = ""
    @Published var limitIbft: String = ""
    
    @Published var destinationName: String = ""
    @Published var fee: String = ""
    @Published var destinationNumber: String = ""
    @Published var reffNumber: String = ""
    
    @Published var cardReplaceFee: String = ""
    
    @Published var status: String = ""
    @Published var messageStatus: String = ""
    
    @Published var transactionDate: String = ""
    
    @Published var limitCifIdr: Int = 0
    @Published var limitUserOnUs: Int = 0
    @Published var limitUserSkn: Int = 0
    @Published var limitUserRtgs: Int = 0
    @Published var limitUserOnline: Int = 0
    
    // MARK: - GET FEE CARD RE
    func getFeeCardReplacement(classCode: String,
                               completion: @escaping (Bool) -> Void) {
        
        TransferServices.shared.getFeeReplacement(classCode: classCode) { result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                self.cardReplaceFee = response.cardReplaceFee
                
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
                        self.message = "Invalid Transaction PIN"
                    default:
                        self.message = "Internal Server Error"
                    }
                }
                
                completion(false)
            }
        }
    }
    
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
                }
                
                self.limitIbftPerTrx = response.maxIbftPerTrans
                self.limitPenarikanHarian = response.limitWd
                self.limitPembayaran = response.limitPayment
                self.limitPembelian = response.limitPurchase
                self.limitIbft = response.limitIbft
                self.limitOnUs = response.limitOnUs
                
                self.cardReplaceFee = response.cardReplaceFee
                
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
                        self.message = "Invalid Transaction PIN"
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
                    self.message = "Invalid Transaction PIN"
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
                    self.messageStatus = response.status.message
                    self.destinationName = response.destinationAccountName ?? ""
                    self.destinationNumber = response.destinationAccountNumber ?? ""
                    self.fee = response.transactionFee ?? ""
                    self.transactionDate = response.transactionDate ?? ""
                    
                    if (response.reffNumber == nil) {
                        self.reffNumber = response.ref ?? ""
                    } else {
                        self.reffNumber = response.reffNumber ?? ""
                    }
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
                    self.message = "Invalid Transaction PIN"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
                case .custom(code: 504):
                    self.code = "504"
                    self.message = "Error Transfer"
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
                    self.message = "Invalid Transaction PIN"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
                case .custom(code: 504):
                    self.code = "504"
                    self.message = "Gateway Timeout"
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
                    self.message = "Invalid Transaction PIN"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
                case .custom(code: 503):
                    self.code = "503"
                    self.message = "Internal Server Error"
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
                    self.message = "Invalid Transaction PIN"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
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
                    self.message = "PIN Transaksi Salah"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - LIMIT USER
    func limitUser(completion: @escaping (Bool) -> Void) {
        TransferServices.shared.limitUser() { result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.isLoading = false
                    
                    response.limits.forEach { (limit) in
                        switch limit.key {
                        case "trxOnCifIdr":
                            print("Cif")
                            self.limitCifIdr = Int(limit.value)
                        case "trxOnCifNonIdr":
                            print("Cif Non Idr")
                        case "trxOnUsIdr":
                            print("On Us")
                            self.limitUserOnUs = Int(limit.value)
                        case "trxOnUsNonIdr":
                            print("On Us Non Idr")
                        case "trxVirtualAccount":
                            print("VA")
                        case "trxSknTransfer":
                            self.limitUserSkn = Int(limit.value)
                        case "trxRtgsTransfer":
                            self.limitUserRtgs = Int(limit.value)
                        case "trxOnlineTransfer":
                            self.limitUserOnline = Int(limit.value)
                        case "trxBillPayment":
                            print("Bill Payment")
                        case "trxPurchase":
                            print("Purchase")
                        default:
                            print("Have you done something new?")
                        }
                    }
                    
                    completion(true)
                }
                
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
                    self.message = "PIN Transaksi Salah"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                case .custom(code: 500):
                    self.code = "500"
                    self.message = "Internal Server Error"
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
                    self.message = "PIN Transaksi Salah"
                case .customWithStatus(code: 406, codeStatus: "406"):
                    self.code = "406"
                    self.message = "Nominal melebihi limit transaksi"
                case .customWithStatus(code: 406, codeStatus: "407"):
                    self.code = "407"
                    self.message = "PIN Transaksi anda salah melebihi batas minimal"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
