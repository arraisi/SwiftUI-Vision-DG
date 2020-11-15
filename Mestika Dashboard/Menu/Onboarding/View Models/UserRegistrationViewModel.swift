//
// Created by Prima Jatnika on 14/11/20.
//

import Foundation

class UserRegistrationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
}

extension UserRegistrationViewModel {

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
}
