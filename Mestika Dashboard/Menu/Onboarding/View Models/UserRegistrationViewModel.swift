//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation

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
        
        UserRegistrationService.shared.postUser() { result in
            switch result {
            case .success(let response):
                print(response.deviceID)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
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
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.code = response.code
//                    self.code = "R05"
                    self.message = response.message
                    
                    completion(true)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                print(error.localizedDescription)
            }
        }
    }
}
