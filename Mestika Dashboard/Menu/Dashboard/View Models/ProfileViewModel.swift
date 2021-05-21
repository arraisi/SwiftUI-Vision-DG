//
//  ProfileViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/02/21.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    // Account Balance
    @Published var creditDebit: String = ""
    
    @Published var profileModel = ProfileResponseModel.self
    
    // Limit
    @Published var maxIbftPerTrans: String = ""
    @Published var limitOnUs: String = ""
    @Published var limitWd: String = ""
    @Published var limitPayment: String = ""
    @Published var limitPurchase: String = ""
    @Published var limitIbft: String = ""
    
    @Published var name: String = ""
    @Published var balance: String = ""
    @Published var nameOnCard: String = ""
    @Published var telepon: String = ""
    @Published var email: String = ""
    @Published var tglLahir: String = ""
    @Published var tempatLahir: String = ""
    @Published var gender: String = ""
    
    @Published var classCode: String = ""
    @Published var cardNo: String = ""
    @Published var cardName: String = ""
    @Published var accountNumber: String = ""
    @Published var productName: String = ""
    
    // Address
    @Published var alamat: String = ""
    @Published var provinsiName: String = ""
    @Published var kabupatenName: String = ""
    @Published var kecamatanName: String = ""
    @Published var kelurahanName: String = ""
//    @Published var rt: String = ""
//    @Published var rw: String = ""
    
    @Published var alamatSuratMenyurat: String = ""
//    @Published var rtSuratMenyurat: String = ""
//    @Published var rwSuratMenyurat: String = ""
    @Published var kodePosSuratMenyurat: String = ""
    @Published var kelurahanSuratMenyurat: String = ""
    @Published var kecamatanSuratMenyurat: String = ""
    @Published var kotaSuratMenyurat: String = ""
    @Published var provinsiSuratMenyurat: String = ""
    
    @Published var tujuanPembukaan: String = ""
    @Published var sumberDana: String = ""
    @Published var jumlahPenarikanPerbulan: String = ""
    @Published var jumlahPenarikanDanaPerbulan: String = ""
    @Published var jumlahSetoranPerbulan: String = ""
    @Published var jumlahSetoranDanaPerbulan: String = ""
    
    @Published var hubunganKeluarga: String = ""
    @Published var namaKeluarga: String = ""
    @Published var alamatKeluarga: String = ""
    @Published var kodePosKeluarga: String = ""
    @Published var kelurahanKeluarga: String = ""
    @Published var kecamatanKeluarga: String = ""
    @Published var teleponKeluarga: String = ""
    
    @Published var pekerjaan: String = ""
    @Published var penghasilanKotor: String = ""
    @Published var PendapatanLainnya: String = ""
    
    @Published var namaPerusahaan: String = ""
    @Published var alamatPerusahaan: String = ""
    @Published var kodePosPerusahaan: String = ""
    @Published var kelurahanPerusahaan: String = ""
    @Published var kecamatanPerusahaan: String = ""
    @Published var teleponPerusahaan: String = ""
    
    @Published var namaPenyandang: String = ""
    @Published var hubunganPenyandang: String = ""
    @Published var pekerjaanPenyandang: String = ""
    
    @Published var errorMessage: String = ""
    @Published var statusCode: String = ""
}

extension ProfileViewModel {
    
    // MARK: - GET CUSTOMER
    func getCustomerFromPhoenix(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.checkCustomer { result in
            switch result {
            case .success(let response):
                print("Success")
                
                self.isLoading = false
                
                self.tujuanPembukaan = response.last?.cdd.tujuanPembukaanRekening ?? ""
                self.sumberDana = response.last?.cdd.sumberDana ?? ""
                self.jumlahPenarikanPerbulan = response.last?.cdd.frequencyPenarikanDana ?? ""
                self.jumlahPenarikanDanaPerbulan = response.last?.cdd.jumlahPenarikanDana ?? ""
                self.jumlahSetoranPerbulan = response.last?.cdd.frequencySetoranDana ?? ""
                self.jumlahSetoranDanaPerbulan = response.last?.cdd.jumlahSetoranDana ?? ""
                
                self.hubunganKeluarga = response.last?.cdd.keluargaTerdekat ?? ""
                self.namaKeluarga = response.last?.cdd.namaKeluargaTerdekat ?? ""
                self.alamatKeluarga = response.last?.cdd.alamatKeluargaTerdekat ?? ""
                self.kodePosKeluarga = response.last?.cdd.kodePosKeluargaTerdekat ?? ""
                self.kelurahanKeluarga = response.last?.cdd.kelurahanKeluargaTerdekat ?? ""
                self.kecamatanKeluarga = response.last?.cdd.kecamatanKeluargaTerdekat ?? ""
                self.teleponKeluarga = response.last?.cdd.teleponKeluargaTerdekat ?? ""
                
                self.pekerjaan = response.last?.cdd.pekerjaan ?? ""
                self.penghasilanKotor = ""
                self.PendapatanLainnya = response.last?.cdd.sumberPendapatanLainnya ?? ""
                
                self.namaPerusahaan = response.last?.cdd.namaPerusahaan ?? ""
                self.alamatPerusahaan = response.last?.cdd.alamatPerusahaan ?? ""
                self.kodePosPerusahaan = response.last?.cdd.kodePosPerusahaan ?? ""
                self.kelurahanPerusahaan = response.last?.cdd.kelurahanPerusahaan ?? ""
                self.kecamatanPerusahaan = response.last?.cdd.kecamatanPerusahaan ?? ""
                self.teleponPerusahaan = response.last?.cdd.teleponPerusahaan ?? ""
                 
                self.namaPenyandang = ""
                self.hubunganPenyandang = ""
                self.pekerjaanPenyandang = ""
                
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.statusCode = "404"
                    self.errorMessage = "USER STATUS NOT FOUND"
                case .custom(code: 401):
                    self.statusCode = "401"
                    self.errorMessage = "LOGEDOUT"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - GET PROFILE
    func getProfile(completion: @escaping (Bool) -> Void) {
        
        print("GET PROFILE COK")
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.checkProfile { result in
            switch result {
            case .success(let response):
                print("Success")
                print("GET PROFILE OK")
                
                self.isLoading = false
            
                self.alamat = response.personal.address
                self.provinsiName = response.personal.propName
                self.kabupatenName = response.personal.kabName
                self.kecamatanName = response.personal.kecName
                self.kelurahanName = response.personal.kelName
//                self.rt = response.personal.rt
//                self.rw = response.personal.rw
                
                print("\n\nVM PROFILE \(response.personal.name)\n\n")
                print("\n\nVM PROFILE \(String(describing: response.chipProfileDto.last!.cardNo))\n\n")
                self.name = response.personal.name
                self.telepon = response.profileResponseModelID.telepon
                self.email = response.profileResponseModelID.surel
                self.nameOnCard = response.products.last!.productName ?? ""
                self.balance = response.chipProfileDto.last!.balance ?? "0"
                self.classCode = response.chipProfileDto.last?.classCode ?? ""
                self.tempatLahir = response.personal.placeOfBirth
                self.tglLahir = response.personal.dateOfBirth
                self.gender = response.personal.gender
                
                self.maxIbftPerTrans = response.chipProfileDto.last?.maxIbftPerTrans ?? "0"
                self.limitOnUs = response.chipProfileDto.last?.limitOnUs ?? "1000000"
                self.limitWd = response.chipProfileDto.last?.limitWd ?? "0"
                self.limitPayment = response.chipProfileDto.last?.limitPayment ?? "0"
                self.limitPurchase = response.chipProfileDto.last?.limitPurchase ?? "0"
                self.limitIbft = response.chipProfileDto.last?.limitIbft ?? "0"
                
                
                self.alamatSuratMenyurat = response.chipProfileDto.last?.postalAddress ?? ""
//                self.rtSuratMenyurat = response.chipProfileDto.last?.rt ?? ""
//                self.rwSuratMenyurat = response.chipProfileDto.last?.rw ?? ""
                self.kodePosSuratMenyurat = response.chipProfileDto.last?.kodepos ?? ""
                self.kelurahanSuratMenyurat = response.chipProfileDto.last?.kelurahan ?? ""
                self.kecamatanSuratMenyurat = response.chipProfileDto.last?.kecamatan ?? ""
                self.kotaSuratMenyurat = response.chipProfileDto.last?.kabupatenKota ?? ""
                self.provinsiSuratMenyurat = response.chipProfileDto.last?.provinsi ?? ""
                
                if let _chipProfileDto = response.chipProfileDto.last {
                    self.cardName = _chipProfileDto.nameOnCard
                    self.cardNo = _chipProfileDto.cardNo ?? ""
                    self.accountNumber = _chipProfileDto.accountNumber
                    print(_chipProfileDto.accountNumber)
                }
                 
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.statusCode = "404"
                    self.errorMessage = "USER STATUS NOT FOUND"
                case .custom(code: 401):
                    self.statusCode = "401"
                    self.errorMessage = "LOGEDOUT"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
    
    // MARK: - GET ACCOUNT BALANCE
    func getAccountBalance(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.getAccountBalance { result in
            switch result {
            case .success(let response):
                print("Success")
                
                self.isLoading = false
                
                if (response.balance == "") {
                    self.balance = "0"
                } else {
                    self.balance = response.balance ?? "0"
                }
    
                self.creditDebit = response.creditDebit
                 
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.errorMessage = "USER STATUS NOT FOUND"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
