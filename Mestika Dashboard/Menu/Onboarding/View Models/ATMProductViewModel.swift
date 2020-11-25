//
//  ATMProductViewModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 24/11/20.
//

import Foundation

class ATMProductViewModel : ObservableObject {
    @Published var isLoading: Bool = false
}

extension ATMProductViewModel {
    // MARK: - POST OTP
    func addProductATM(dataRequest: AddProductATM, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
//            MARK : ADD ACTION
        }
        
        ATMService.shared.postAddProductATM(dataRequest: dataRequest) { result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                if (response.status) {
                    print("Valid")
                    completion(true)
                }
                break
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}
