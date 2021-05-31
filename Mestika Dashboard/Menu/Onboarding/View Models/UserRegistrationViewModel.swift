//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation
import SwiftUI

class UserRegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var code: String = ""
    @Published var message: String = ""
    @Published var phoneNumber: String = ""
    @Published var reference: String = ""
    @Published var fingerprintFlag: Bool = false
    @Published var user: UserCheckResponse?
}

extension UserRegistrationViewModel {
    
    /* REGISTER USER */
    func userRegistration(registerData: RegistrasiModel, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let imageKtp = registerData.fotoKTP.asUIImage()
        let imageKtpCompress = imageKtp.resized(withPercentage: 0.1)
        
        let imageSelfie = registerData.fotoSelfie.asUIImage()
        let imageSelfieCompress = imageSelfie.resized(withPercentage: 0.1)
        
        let imageNpwp = registerData.fotoNPWP.asUIImage()
        let imageNpwpCompress = imageNpwp.resized(withPercentage: 0.1)
        
        print("registerData.perkiraanPenarikan \(registerData.perkiraanPenarikan)")
        print("registerData.besarPerkiraanPenarikan \(registerData.besarPerkiraanPenarikan)")
        
        UserRegistrationService.shared.postUser(
            registerData: registerData,
            imageKtp: imageKtpCompress!,
            imageNpwp: imageNpwpCompress!,
            imageSelfie: imageSelfieCompress!) { result in
                
            switch result {
            case .success(_ ):
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 500):
                    print("Something Happen With System")
                    DispatchQueue.main.async {
                        self.message = "Something Happen With System"
                    }
                default:
                    print("ERRROR")
                }
                completion(false)
            }
        }
    }
    
    /* CHECK USER */
    func userCheck(deviceId: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        UserRegistrationService.shared.getUser(deviceId: deviceId) { result in
            switch result {
            case .success(let response):
                print(response.code as Any)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    completion(true)
                }
                
                DispatchQueue.main.async {
                    self.code = response.code ?? ""
//                    self.code = "R07"
                    self.message = response.message ?? ""
//                    self.message = "KYC_WAITING"
                    self.fingerprintFlag = response.fingerprintFlag ?? false
                    if let phone = response.phoneNumber {
                        self.phoneNumber = phone
                    }
                    
                    if let reference = response.reference {
                        self.reference = reference
                    }
                    
                    self.user = response
                    
                    completion(true)
                }
                
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
    
    /* CANCEL REGISTRATION */
    func cancelRegistration(nik: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        UserRegistrationService.shared.cancelRequest(nik: nik) { result in
            switch result {
            case .success( _):
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(true)
                }
                
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
