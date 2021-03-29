//
//  AddressViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation

class AddressSummaryViewModel: ObservableObject {
    
    private var _addressModels = [AddressSugestionResponse]()
    private var _addressResultModels = [AddressSugestionResultResponse]()
    
    @Published var address = [AddressViewModel]()
    @Published var addressResult = [AddressResultViewModel]()
    @Published var isLoading: Bool = false
    
    @Published var message: String = ""
    @Published var code: String = ""
    
    // MARK:- GET ALL ADDRESS RESULT
    func getAddressSugestionResult(addressInput: String, completion: @escaping (Bool) -> Void) {
        if address.count > 0 {
            self.isLoading = false
            completion(true)
            return
        }
        
        AddressService.shared.getAddressSugestionResult(addressInput: addressInput) { result in
            print(result)
            
            switch result {
            case .success(let addressResult):
                print("Length Data Address : \(addressResult?.count)")
                
                if let addressResult = addressResult {
                    self.isLoading = false
                    self._addressResultModels = addressResult
                    self.addressResult = addressResult.map(AddressResultViewModel.init)
                }
                
                completion(true)
            case .failure(let error):
                print("Error Get Address")
                self.isLoading = false
                print(error.localizedDescription)
                
                switch error {
                case .custom(code: 400):
                    self.message = "Masukkan Alamat Lengkap!"
                default:
                    self.message = "Internal Server Error"
                }
                
                completion(false)
            }
        }
    }
    
    // MARK:- GET ALL ADDRESS
    func getAddressSugestion(addressInput: String, completion: @escaping (Bool) -> Void) {
        if address.count > 0 {
            self.isLoading = false
            completion(true)
            return
        }
        
        AddressService.shared.getAddressSugestion(addressInput: addressInput) { result in
            print(result)
            
            switch result {
            case .success(let address):
                print("Length Data Address : \(address?.count)")
                
                if let address = address {
                    self.isLoading = false
                    self._addressModels = address
                    self.address = address.map(AddressViewModel.init)
                }
                
                completion(true)
            case .failure(let error):
                print("Error Get Address")
                self.isLoading = false
                print(error.localizedDescription)
                
                switch error {
                case .custom(code: 400):
                    self.message = "Masukkan Alamat Lengkap!"
                default:
                    self.message = "Address not found"
                }
                
                completion(false)
            }
        }
    }
}

class AddressViewModel {
    
    var address: AddressSugestionResponse
    
    init(address: AddressSugestionResponse) {
        self.address = address
    }
    
    var formatted_address: String {
        return self.address.formatted_address
    }
    
    var streetNumber: String {
        return self.address.streetNumber
    }
    
    var placeName: String {
        return self.address.placeName
    }
    
    var street: String {
        return self.address.street
    }
    
    var rt: String {
        return self.address.rt
    }
    
    var rw: String {
        return self.address.rw
    }
    
    var wilayah: String {
        return self.address.wilayah
    }
    
    var kelurahan: String {
        return self.address.kelurahan
    }
    
    var kecamatan: String {
        return self.address.kecamatan
    }
    
    var city: String {
        return self.address.city
    }
    
    var province: String {
        return self.address.province
    }
    
    var country: String {
        return self.address.country
    }
    
    var postalCode: String {
        return self.address.postalCode
    }
}

class AddressResultViewModel {
    
    var address: AddressSugestionResultResponse
    
    init(address: AddressSugestionResultResponse) {
        self.address = address
    }
    
    var formatted_address: String {
        return self.address.formatted_address
    }
}
