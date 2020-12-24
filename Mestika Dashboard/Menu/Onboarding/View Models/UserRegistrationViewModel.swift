//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation
import SwiftUI

class UserRegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var code: String = ""
    @Published var message: String = ""
    @Published var user: UserCheckResponse?
}

extension UserRegistrationViewModel {
    
    /* REGISTER USER */
    func userRegistration(registerData: RegistrasiModel, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let url = URL(string: "https://disdukcapil.soppengkab.go.id/wp-content/uploads/2017/03/KTPEL.jpg")
        let data = try? Data(contentsOf: url!)
        
        let imageKtp = registerData.fotoKTP.asUIImage()
        let imageKtpCompress = imageKtp.resized(withPercentage: 0.1)
        
        let imageSelfie = registerData.fotoSelfie.asUIImage()
        let imageSelfieCompress = imageSelfie.resized(withPercentage: 0.1)
        
        UserRegistrationService.shared.postUser(
            registerData: registerData,
            imageKtp: imageKtpCompress!,
            imageNpwp: UIImage(data: data!)!,
            imageSelfie: imageSelfieCompress!) { result in
                
            switch result {
            case .success(let response):
                
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
                    print("Internal Server Error")
                    self.message = "Internal Server Error"
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
                print(response.code)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    completion(true)
                }
                
                DispatchQueue.main.async {
                    self.code = response.code ?? ""
//                    self.code = "R05"
                    self.message = response.message ?? ""
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
