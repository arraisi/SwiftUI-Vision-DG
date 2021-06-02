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
    
    /* Master Value */
    @Published var provinceResult = MasterProvinceResponse()
    @Published var regencyResult = MasterRegencyResponse()
    @Published var districtResult = MasterDistrictResponse()
    @Published var vilageResult = MasterVilageResponse()
    
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
                print("Length Data Address : \(String(describing: addressResult?.count))")
                
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
                print("Length Data Address : \(String(describing: address?.count))")
                
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
    
    // MARK:- GET MASTER PROVINCE
    func getAllProvince(completion: @escaping (Bool) -> Void) {
        
        self.isLoading = true
        
        AddressService.shared.getAllProvince { result in
            print(result)
            
            switch result {
            case .success(let response):
                self.isLoading = false
                print("Length Data Province : \(String(describing: response.count))")
                self.provinceResult = response
                completion(true)
                
            case .failure(let error):
                print("Error Get Province")
                self.isLoading = false
                
                switch error {
                default:
                    self.message = "Internal Server Error"
                }
                
                completion(false)
            }
        }
    }
    
    // MARK:- GET REGENCY BY ID PROVINCE
    func getRegencyByIdProvince(idProvince: String, completion: @escaping (Bool) -> Void) {
        
        self.isLoading = true
        
        AddressService.shared.getAllRegencyByIdProvince(idProvince: idProvince) { result in
            print(result)
            
            switch result {
            case .success(let response):
                self.isLoading = false
                print("Length Data Regency : \(String(describing: response.count))")
                self.regencyResult = response
                completion(true)
                
            case .failure(let error):
                print("Error Get Regency")
                self.isLoading = false
                
                switch error {
                default:
                    self.message = "Internal Server Error"
                }
                
                completion(false)
            }
        }
    }
    
    // MARK:- GET DISTRICT BY ID REGENCY
    func getDistrictByIdRegency(idRegency: String, completion: @escaping (Bool) -> Void) {
        
        self.isLoading = true
        
        AddressService.shared.getAllDistrictByIdRegency(idRegency: idRegency) { result in
            print(result)
            
            switch result {
            case .success(let response):
                self.isLoading = false
                print("Length Data District : \(String(describing: response.count))")
                self.districtResult = response
                completion(true)
                
            case .failure(let error):
                print("Error Get District")
                self.isLoading = false
                
                switch error {
                default:
                    self.message = "Internal Server Error"
                }
                
                completion(false)
            }
        }
    }
    
    // MARK:- GET VILAGE BY ID DISTRICT
    func getVilageByIdDistrict(idDistrict: String, completion: @escaping (Bool) -> Void) {
        
        self.isLoading = true
        
        AddressService.shared.getAllVilageByIdDistrict(idDistrict: idDistrict) { result in
            print(result)
            
            switch result {
            case .success(let response):
                self.isLoading = false
                print("Length Data Vilage : \(String(describing: response.count))")
                self.vilageResult = response
                completion(true)
                
            case .failure(let error):
                print("Error Get Vilage")
                self.isLoading = false
                
                switch error {
                default:
                    self.message = "Internal Server Error"
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
