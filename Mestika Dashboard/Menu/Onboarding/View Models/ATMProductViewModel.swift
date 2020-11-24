//
//  ATMProductViewModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 24/11/20.
//

import Foundation

class ATMProductViewModel : ObservableObject {
    
}

extension ATMProductViewModel {
    // MARK: - POST OTP
    func addProductATM(dataRequest: AddProductATM, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
//            self.isLoading = true
//            MARK : ADD ACTION
        }
        
        ATMService.shared.postAddProductATM(dataRequest: AddProductATM) { result in
            switch result {
            case.success(let _): break
            //                if (response.status != nil) {
            //                    print("Valid")
            //
            //
            //                }
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
//                    self.isLoading = false
                }
                print(error.localizedDescription)
            }
        }
    }
}
