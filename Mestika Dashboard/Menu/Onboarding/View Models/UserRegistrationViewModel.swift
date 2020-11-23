//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation
import SwiftUI

class UserRegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var code: String = ""
    @Published var message: String = ""
}

extension UserRegistrationViewModel {
    
    /* REGISTER USER */
    func userRegistration(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        UserRegistrationService.shared.postUser(
            imageKtp: UIImage(named: "atm_red_devils")!,
            imageNpwp: UIImage(named: "atm_red_devils")!,
            imageSelfie: UIImage(named: "atm_red_devils")!) { result in
                
            switch result {
            case .success(let response):
                print(response.deviceID)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                
                completion(true)
                
            case .failure(let error):
                
                print("ERROR-->")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                }
                completion(false)
                
                print(error.localizedDescription)
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
                    
                    self.code = response.code
//                    self.code = "R05"
                    self.message = response.message
                    
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
