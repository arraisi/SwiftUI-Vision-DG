//
//  AuthViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/01/21.
//

import Foundation
import Combine
import SwiftyRSA

class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var fingerprintFlag: Bool = false
    @Published var nik: String = ""
    @Published var password: String = ""
    @Published var phoneNumber: String = ""
    @Published var pinTransaction: String = ""
    @Published var status: String = ""
    @Published var errorMessage: String = ""
}

extension AuthViewModel {
    
    // MARK: - POST LOGIN
    func postLogin(
        password: String,
        phoneNumber: String,
        fingerCode: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.login(password: encryptPassword(password: password), phoneNumber: phoneNumber, fingerCode: fingerCode) { result in
            switch result {
            case .success(let response):
                print("Success")
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST LOGIN NEW DEVICE
    func postLoginNewDevice(
        password: String,
        phoneNumber: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.loginNewDevice(password: encryptPassword(password: password), phoneNumber: phoneNumber) { result in
            switch result {
            case .success( _):
                print("Success")
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST LOGOUT
    func postLogout(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.logout() { result in
            switch result {
            case .success(let response):
                print("Success")
                print("response \(response)")
                self.isLoading = false
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST VALIDATE PIN VRF
    func validatePinVrf(
        accountNumber: String,
        pinTrx: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.validatePinVerf(accountNumber: accountNumber, pinTrx: encryptPassword(password: pinTrx)) { result in
            switch result {
            case .success(let response):
                print("Success")
                self.status = response.message!
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST VALIDATE PIN TRX
    func validatePinTrx(
        accountNumber: String,
        pinTrx: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.validatePinTrx(accountNumber: accountNumber, pinTrx: encryptPassword(password: pinTrx)) { result in
            switch result {
            case .success(let response):
                print("Success")
                self.status = response.message!
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    
    // MARK: - POST SET PWD
    func setPwd(
        pwd: String,
        accountNumber: String,
        nik: String,
        pinTrx: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.setPassword(
            pwd: encryptPassword(password: pwd),
            accountNumber: accountNumber,
            nik: nik,
            pinTrx: encryptPassword(password: pinTrx)) { result in
            
            switch result {
            case .success(let response):
                print("Success")
                self.status = response.message!
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 403):
                    self.errorMessage = "Password not changed"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST FORGOT PASSWORD WITHOUT PIN TRX
    func forgotPassword(
        newPwd: String,
        cardNo: String,
        pinAtm: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.forgotPassword(
            newPwd: encryptPassword(password: newPwd),
            cardNo: cardNo,
            pinAtm: encryptPassword(password: pinAtm)) { result in
            
            switch result {
            case .success(let response):
                print("Success")
                self.status = response.message!
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 403):
                    self.errorMessage = "PIN not changed"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    
    // MARK: - POST SET FINGER PRINT
    func enableBiometricLogin(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.enableBiometricLogin() { result in
            
            switch result {
            case .success(let response):
                print("Success \(response)")
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 403):
                    self.errorMessage = "Password not changed"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST SET FINGER PRINT
    func disableBiometricLogin(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.disableBiometricLogin() { result in
            
            switch result {
            case .success(let response):
                print("Success \(response)")
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 401):
                    DispatchQueue.main.async {
                        self.errorMessage = "Unauthorized"
                    }
                case .custom(code: 403):
                    self.errorMessage = "Password not changed"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST SET FINGER PRINT
    func changePasswordApp(currentPwd: String, newPwd: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.changePassword(currentPwd: encryptPassword(password: currentPwd), newPwd: encryptPassword(password: newPwd)) { result in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            switch result {
            case .success(let response):
                print("Success \(response)")
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    switch error {
                    case .custom(code: 401):
                        DispatchQueue.main.async {
                            self.errorMessage = "Unauthorized"
                        }
                    case .custom(code: 403):
                        self.errorMessage = "Password not changed"
                    case .custom(code: 406):
                        self.errorMessage = "Password lemah, silahkan ganti password anda"
                    case .custom(code: 500):
                        self.errorMessage = "Internal Server Error"
                    default:
                        self.errorMessage = "Internal Server Error"
                    }
                }
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST SET FINGER PRINT
    func changePinTrx(currentPinTrx: String, newPinTrx: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.changePinTransaksi(currentPinTrx: encryptPassword(password: currentPinTrx), newPinTrx: encryptPassword(password: newPinTrx)) { result in
            
            
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            switch result {
            case .success(let response):
                print("Success \(response)")
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 401):
                    DispatchQueue.main.async {
                        self.errorMessage = "Unauthorized"
                    }
                case .custom(code: 403):
                    DispatchQueue.main.async {
                        self.errorMessage = "Password not changed"
                        self.isLoading = false
                    }
                default:
                    self.errorMessage = "Internal Server Error"
                }
                
                completion(false)
            }
        }
        
    }
    
    // MARK: - POST SET FINGER PRINT
    func forgotPinTransaksi(cardNo: String, pin: String, newPinTrx: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AuthService.shared.forgotPinTransaksi(cardNo: cardNo, pin: encryptPassword(password: pin), newPinTrx: encryptPassword(password: newPinTrx)) { result in
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            switch result {
            case .success(let response):
                print("Success \(response)")
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                switch error {
                case .custom(code: 500):
                    self.errorMessage = "Internal Server Error"
                case .custom(code: 400):
                    self.errorMessage = "Password lemah,silahkan ganti password anda"
                case .custom(code: 401):
                    DispatchQueue.main.async {
                        self.errorMessage = "Unauthorized"
                    }
                case .custom(code: 403):
                    self.errorMessage = "Password not changed"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                
                completion(false)
            }
        }
        
    }
    
    func encryptPassword(password: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: password, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
        //        self.registerData.password = base64String
    }
}
