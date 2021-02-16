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
    
    // MARK: - Transfer ONUS INQUIRY
    func transferOnUsInquiry(transferData: TransferOnUsModel,
                      completion: @escaping (Bool) -> Void) {
        TransferServices.shared.transferOnUs(transferData: transferData) {result in
            print(result)
            
            switch result {
            case .success(let response):
                print(response)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                    self.code = "403"
                    self.message = "Over Booking failed"
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                    self.code = "403"
                    self.message = "Over Booking failed"
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
                    self.code = "403"
                    self.message = "RTGS failed"
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
                    self.code = "403"
                    self.message = "SKN failed"
                default:
                    self.message = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
