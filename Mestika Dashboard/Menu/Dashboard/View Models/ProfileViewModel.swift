//
//  ProfileViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/02/21.
//

import Foundation
import Combine
import SwiftyRSA

class ProfileViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    // Account Balance
    @Published var creditDebit: String = ""
    
    @Published var profileModel = ProfileResponseModel.self
    
    // ID
    @Published var id: String = ""
    @Published var nik: String = ""
    @Published var firebaseId: String = ""
    @Published var firebaseToken: String = ""
    @Published var deviceId: String = ""
    @Published var cif: String = ""
    
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
    @Published var kabupatenSuratMenyurat: String = ""
    @Published var provinsiSuratMenyurat: String = ""
    
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
    @Published var kotaPerusahaan: String = ""
    @Published var provinsiPerusahaan: String = ""
    @Published var teleponPerusahaan: String = ""
    
    @Published var namaPenyandang: String = ""
    @Published var hubunganPenyandang: String = ""
    @Published var pekerjaanPenyandang: String = ""
    
    @Published var freezeAccount: Bool = false
    
    @Published var errorMessage: String = ""
    @Published var statusCode: String = ""
    
    @Published var existingCustomer: Bool = false
    
    @Published var marital: String = ""
    @Published var noKec: String = ""
    @Published var noKel: String = ""
    @Published var rw: String = ""
    @Published var rt: String = ""
    @Published var namaIbuKandung: String = ""
}

extension ProfileViewModel {
    
    func convertSpecialCharacters(string: String) -> String {
            var newString = string
            let char_dictionary = [
                "&amp;" : "&",
                "&lt;" : "<",
                "&gt;" : ">",
                "&quot;" : "\"",
                "&apos;" : "'"
            ];
            for (escaped_char, unescaped_char) in char_dictionary {
                newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
            }
            return newString
    }
    
    func encryptPassword(password: String) -> String {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: password, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        
        return base64String
        //        self.registerData.password = base64String
    }
    
    func updateCustomerPhoenix(pinTrx: String, completion: @escaping (Bool) -> Void) {
        let bodyRequest: [String: Any] = [
            "_id": self.id,
            "id": [
                "surel": self.email,
                "telepon": self.telepon,
                "nik": self.nik,
                "firebaseId": self.firebaseId,
                "firebaseToken": self.firebaseToken,
                "deviceId": self.deviceId,
                "cif": self.cif
            ],
            "personal": [
                "gender": self.gender,
                "dateOfBirth": self.tglLahir,
                "placeOfBirth": self.tempatLahir,
                "name": self.name,
                "address": self.alamat,
                "kabName": self.kabupatenName,
                "kecName": self.kecamatanName,
                "kelName": self.kelurahanName,
                "propName": self.provinsiName,
                "marital": self.marital,
                "namaIbuKandung": self.namaIbuKandung,
                "noKab": "0",
                "noKec": self.noKec,
                "noKel": self.noKel,
                "rt": self.rt,
                "rw": self.rw,
                "existingCustomer": self.existingCustomer,
                "kodePos": "40287"
            ],
            "cdd": [
                "penghasilanKotorTahunan": self.penghasilanKotor,
                "sumberPendapatanLainnya": self.PendapatanLainnya,
                "jumlahSetoranDana": self.jumlahSetoranDanaPerbulan,
                "frequencySetoranDana": self.jumlahSetoranPerbulan,
                "jumlahPenarikanDana": self.jumlahPenarikanDanaPerbulan,
                "frequencyPenarikanDana": self.jumlahPenarikanPerbulan,
                "sumberDana": self.sumberDana,
                "tujuanPembukaanRekening": self.tujuanPembukaan,
                "namaPerusahaan": self.namaPerusahaan,
                "hpPerusahaan": self.teleponPerusahaan,
                "alamatPerusahaan": self.alamatPerusahaan,
                "kodePosPerusahaan": self.kodePosPerusahaan,
                "kecamatanPerusahaan": self.kecamatanPerusahaan,
                "kelurahanPerusahaan": self.kelurahanPerusahaan,
                "teleponPerusahaan": self.teleponPerusahaan,
                "kabupatenPerusahaan": self.kotaPerusahaan,
                "provinsiPerusahaan": self.provinsiPerusahaan,
                "pekerjaan": self.pekerjaan,
                "kecamatanSuratMenyurat" : self.kecamatanSuratMenyurat,
                "kelurahanSuratMenyurat" : self.kelurahanSuratMenyurat,
                "alamatSuratMenyurat" : self.alamatSuratMenyurat,
                "provinsiSuratMenyurat" : self.provinsiSuratMenyurat,
                "kabupatenSuratMenyurat" : self.kabupatenSuratMenyurat,
                "kodePosSuratMenyurat" : self.kodePosSuratMenyurat
            ],
            "pinTrx": encryptPassword(password: pinTrx)
        ]
        
        ProfileService.shared.updateCustomerPhoenix(body: bodyRequest) { result in
            switch result {
            case .success(_):
                print("Success")
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                    
                    completion(true)
                }
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 400):
                    self.statusCode = "400"
                    self.errorMessage = "Phone Number cannot be used"
                case .custom(code: 406):
                    self.statusCode = "406"
                    self.errorMessage = "PIN TRANSAKSI TERBLOKIR"
                case .custom(code: 403):
                    self.statusCode = "403"
                    self.errorMessage = "PIN TRANSAKSI SALAH"
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
    
    // MARK: - GET CUSTOMER
    func getCustomerFromPhoenix(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.checkCustomer { result in
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("Success")
                    
                    // ID
                    self.id = response.last?.id ?? ""
                    self.nik = ""
                    self.firebaseId = ""
                    self.firebaseToken = ""
                    self.deviceId = ""
                    self.cif = ""
                    
                    self.tujuanPembukaan = response.last?.cdd.tujuanPembukaanRekening ?? ""
                    self.sumberDana = response.last?.cdd.sumberDana ?? ""
//                    self.jumlahPenarikanPerbulan = self.convertSpecialCharacters(string: response.last?.cdd.frequencyPenarikanDana ?? "")
//                    self.jumlahPenarikanDanaPerbulan = self.convertSpecialCharacters(string: response.last?.cdd.jumlahPenarikanDana ?? "")
//                    self.jumlahSetoranPerbulan = self.convertSpecialCharacters(string: response.last?.cdd.frequencySetoranDana ?? "")
//                    self.jumlahSetoranDanaPerbulan = self.convertSpecialCharacters(string: response.last?.cdd.jumlahSetoranDana ?? "")
                    
                    let jmlStrData = self.convertSpecialCharacters(string: response.last?.cdd.jumlahSetoranDana ?? "")
                    
                    let frqStrData = self.convertSpecialCharacters(string: response.last?.cdd.frequencySetoranDana ?? "")
                    
                    let jmlPenDana = self.convertSpecialCharacters(string: response.last?.cdd.jumlahPenarikanDana ?? "")
                    
                    let frqPenDana = self.convertSpecialCharacters(string: response.last?.cdd.frequencyPenarikanDana ?? "")
                    
                    self.jumlahSetoranDanaPerbulan = jmlStrData
                    self.jumlahSetoranPerbulan = frqStrData
                    self.jumlahPenarikanDanaPerbulan = frqPenDana
                    self.jumlahPenarikanPerbulan = jmlPenDana
                    
//                    if (jmlStrData == "<=30_JUTA") {
//                        self.jumlahSetoranDanaPerbulan = "<= 30 Juta"
//                    } else if (jmlStrData == ">30-60_JUTA") {
//                        self.jumlahSetoranDanaPerbulan = "> 30 - 60 Juta"
//                    } else if (jmlStrData == ">60_JUTA") {
//                        self.jumlahSetoranDanaPerbulan = "> 60 Juta"
//                    } else {
//                        self.jumlahSetoranDanaPerbulan = jmlStrData
//                    }
//
//                    if (frqStrData == "0–10_KALI") {
//                        self.jumlahSetoranPerbulan = "0 – 10 Kali"
//                    } else if (frqStrData == ">10-25_KALI") {
//                        self.jumlahSetoranPerbulan = "> 10 - 25 Kali"
//                    } else if (frqStrData == ">25_KALI") {
//                        self.jumlahSetoranDanaPerbulan = "> 25 Kali"
//                    } else {
//                        self.jumlahSetoranDanaPerbulan = frqStrData
//                    }
//
//                    if (jmlPenDana == "<=30_JUTA") {
//                        self.jumlahPenarikanDanaPerbulan = "<= 30 Juta"
//                    } else if (jmlPenDana == ">30-60_JUTA") {
//                        self.jumlahPenarikanDanaPerbulan = "> 30 - 60 Juta"
//                    } else if (jmlPenDana == ">60_JUTA") {
//                        self.jumlahPenarikanDanaPerbulan = "> 60 Juta"
//                    } else {
//                        self.jumlahPenarikanDanaPerbulan = jmlPenDana
//                    }
//
//                    if (frqPenDana == "0–10_KALI") {
//                        self.jumlahPenarikanPerbulan = "0 – 10 Kali"
//                    } else if (frqPenDana == ">10-25_KALI") {
//                        self.jumlahPenarikanPerbulan = "> 10 - 25 Kali"
//                    } else if (frqPenDana == ">25_KALI") {
//                        self.jumlahPenarikanPerbulan = "> 25 Kali"
//                    } else {
//                        self.jumlahPenarikanPerbulan = frqPenDana
//                    }

                    self.hubunganKeluarga = response.last?.cdd.keluargaTerdekat ?? ""
                    self.namaKeluarga = response.last?.cdd.namaKeluargaTerdekat ?? ""
                    self.alamatKeluarga = response.last?.cdd.alamatKeluargaTerdekat ?? ""
                    self.kodePosKeluarga = response.last?.cdd.kodePosKeluargaTerdekat ?? ""
                    self.kelurahanKeluarga = response.last?.cdd.kelurahanKeluargaTerdekat ?? ""
                    self.kecamatanKeluarga = response.last?.cdd.kecamatanKeluargaTerdekat ?? ""
                    self.teleponKeluarga = response.last?.cdd.teleponKeluargaTerdekat ?? ""
                    
                    self.pekerjaan = response.last?.cdd.pekerjaan ?? ""
                    

                    
                    let penghasilanKtr = self.convertSpecialCharacters(string: response.last?.cdd.penghasilanKotorTahunan ?? "")
                    
                    if (penghasilanKtr == "<RP_50_JUTA") {
                        self.penghasilanKotor = "< Rp 50 Juta"
                    } else if (penghasilanKtr == "RP_50_JUTA-RP_100_JUTA") {
                        self.penghasilanKotor = "Rp 50 Juta - Rp 100 Juta"
                    } else if (penghasilanKtr == "RP_100_JUTA-RP_250_JUTA") {
                        self.penghasilanKotor = "Rp 100 Juta - Rp 250 Juta"
                    } else if (penghasilanKtr == "RP_250_JUTA-RP_500_JUTA") {
                        self.penghasilanKotor = "Rp 250 Juta - Rp 500 Juta"
                    } else if (penghasilanKtr == ">RP_500_Juta") {
                        self.penghasilanKotor = "> Rp 500 Juta"
                    } else {
                        self.penghasilanKotor = penghasilanKtr
                    }
                    
                    self.PendapatanLainnya = response.last?.cdd.sumberPendapatanLainnya ?? "Tidak ada"
                    
                    self.namaPerusahaan = response.last?.cdd.namaPerusahaan ?? ""
                    self.alamatPerusahaan = response.last?.cdd.alamatPerusahaan ?? ""
                    self.kodePosPerusahaan = response.last?.cdd.kodePosPerusahaan ?? ""
                    self.kelurahanPerusahaan = response.last?.cdd.kelurahanPerusahaan ?? ""
                    self.kecamatanPerusahaan = response.last?.cdd.kecamatanPerusahaan ?? ""
                    self.kotaPerusahaan = response.last?.cdd.kabupatenPerusahaan ?? ""
                    self.provinsiPerusahaan = response.last?.cdd.provinsiPerusahaan ?? ""
                    self.teleponPerusahaan = response.last?.cdd.teleponPerusahaan ?? ""
                    
                    self.namaPenyandang = ""
                    self.hubunganPenyandang = ""
                    self.pekerjaanPenyandang = ""
                    
                    // PERSONAL DATA
                    self.email = response.last?.customerFromPhoenixResponseID.surel ?? ""
                    self.telepon = response.last?.customerFromPhoenixResponseID.telepon ?? ""
                    self.name = response.last?.personal.name ?? ""
                    self.tempatLahir = response.last?.personal.placeOfBirth ?? ""
                    self.tglLahir = response.last?.personal.dateOfBirth ?? ""
                    self.gender = response.last?.personal.gender ?? ""
                    
                    // ADDRESS
                    self.alamat = response.last?.personal.address ?? ""
                    self.provinsiName = response.last?.personal.propName ?? ""
                    self.kabupatenName = response.last?.personal.kabName ?? ""
                    self.kecamatanName = response.last?.personal.kecName ?? ""
                    self.kelurahanName = response.last?.personal.kelName ?? ""
                    
                    // MAILING ADDRESS
                    self.alamatSuratMenyurat = response.last?.cdd.alamatSuratMenyurat ?? ""
                    self.kelurahanSuratMenyurat = response.last?.cdd.kelurahanSuratMenyurat ?? ""
                    self.kecamatanSuratMenyurat = response.last?.cdd.kecamatanSuratMenyurat ?? ""
                    self.kabupatenSuratMenyurat = response.last?.cdd.kabupatenSuratMenyurat ?? ""
                    self.provinsiSuratMenyurat = response.last?.cdd.provinsiSuratMenyurat ?? ""
                    self.kodePosSuratMenyurat = response.last?.cdd.kodePosSuratMenyurat ?? ""
                    self.existingCustomer = response.last?.personal.existingCustomer ?? false
                    
                    self.marital = response.last?.personal.marital ?? ""
                    self.noKec = response.last?.personal.noKec ?? ""
                    self.noKel = response.last?.personal.noKel ?? ""
                    self.rw = response.last?.personal.rw ?? ""
                    self.rt = response.last?.personal.rt ?? ""
                    self.namaIbuKandung = response.last?.personal.namaIbuKandung ?? ""
                    
                    print("Complete fetch customer phoenix vm  ie. (email) : \(response.last?.customerFromPhoenixResponseID.surel ?? "") published email: \(self.email)")
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
    }
    
    // MARK: - GET CUSTOMER ADDRESS
    func getCustomerAddress(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.customerAddress { result in
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("Success")
                    
                    response.forEach { data in
                        
                        // ALAMAT PERUSAHAAN
                        self.namaPerusahaan = data.companyAddress.namaPerusahaan ?? ""
                        self.alamatPerusahaan = data.companyAddress.alamatPerusahaan ?? ""
                        self.kodePosPerusahaan = data.companyAddress.kodePosPerusahaan ?? ""
                        self.kelurahanPerusahaan = data.companyAddress.kelurahanPerusahaan ?? ""
                        self.kecamatanPerusahaan = data.companyAddress.kecamatanPerusahaan ?? ""
                        self.kotaPerusahaan = data.companyAddress.kabupatenPerusahaan ?? ""
                        self.provinsiPerusahaan = data.companyAddress.provinsiPerusahaan ?? ""
                        self.teleponPerusahaan = data.companyAddress.teleponPerusahaan ?? ""
                        
                        // ALAMAT KTP
                        self.alamat = data.ktpAddress.address ?? ""
                        self.provinsiName = data.ktpAddress.propName ?? ""
                        self.kabupatenName = data.ktpAddress.kabName ?? ""
                        self.kecamatanName = data.ktpAddress.kecName ?? ""
                        self.kelurahanName = data.ktpAddress.kelName ?? ""
                        
                        // MAILING ADDRESS
                        self.alamatSuratMenyurat = data.mailingAddress.alamatSuratMenyurat ?? ""
                        self.kelurahanSuratMenyurat = data.mailingAddress.kelurahanSuratMenyurat ?? ""
                        self.kecamatanSuratMenyurat = data.mailingAddress.kecamatanSuratMenyurat ?? ""
                        self.kabupatenSuratMenyurat = data.mailingAddress.kabupatenSuratMenyurat ?? ""
                        self.provinsiSuratMenyurat = data.mailingAddress.provinsiSuratMenyurat ?? ""
                        self.kodePosSuratMenyurat = data.mailingAddress.kodePosSuratMenyurat ?? ""
                    }
                    
                    print("Complete fetch Customer Address")
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
                
                self.alamat = response.personal.address ?? ""
                self.provinsiName = response.personal.propName ?? ""
                self.kabupatenName = response.personal.kabName ?? ""
                self.kecamatanName = response.personal.kecName ?? ""
                self.kelurahanName = response.personal.kelName ?? ""
                self.name = response.personal.name ?? ""
                self.telepon = response.profileResponseModelID.telepon
                self.email = response.profileResponseModelID.surel
                self.nameOnCard = response.products.last!.productName
                self.balance = response.chipProfileDto.last!.balance ?? "0"
                self.classCode = response.chipProfileDto.last?.classCode ?? ""
                self.tempatLahir = response.personal.placeOfBirth ?? ""
                self.tglLahir = response.personal.dateOfBirth ?? ""
                self.gender = response.personal.gender ?? ""
                
                self.maxIbftPerTrans = response.chipProfileDto.last?.maxIbftPerTrans ?? "0"
                self.limitOnUs = response.chipProfileDto.last?.limitOnUs ?? "1000000"
                self.limitWd = response.chipProfileDto.last?.limitWd ?? "0"
                self.limitPayment = response.chipProfileDto.last?.limitPayment ?? "0"
                self.limitPurchase = response.chipProfileDto.last?.limitPurchase ?? "0"
                self.limitIbft = response.chipProfileDto.last?.limitIbft ?? "0"
                
                
                self.alamatSuratMenyurat = response.chipProfileDto.last?.postalAddress ?? ""
                self.kodePosSuratMenyurat = response.chipProfileDto.last?.kodepos ?? ""
                self.kelurahanSuratMenyurat = response.chipProfileDto.last?.kelurahan ?? ""
                self.kecamatanSuratMenyurat = response.chipProfileDto.last?.kecamatan ?? ""
                self.kabupatenSuratMenyurat = response.chipProfileDto.last?.kabupatenKota ?? ""
                self.kodePosSuratMenyurat = response.chipProfileDto.last?.kodepos ?? ""
                self.provinsiSuratMenyurat = response.chipProfileDto.last?.provinsi ?? ""
                
                if let _chipProfileDto = response.chipProfileDto.last {
                    self.cardName = _chipProfileDto.nameOnCard ?? ""
                    self.cardNo = _chipProfileDto.cardNo ?? ""
                    self.accountNumber = _chipProfileDto.accountNumber ?? ""
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
                    self.errorMessage = "Token Expired"
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
    
    // MARK: - GET FREEZE ACCOUNT
    func getAccountFreeze(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        ProfileService.shared.checkFreeze { result in
            switch result {
            case .success(let response):
                print("Success")
                
                self.isLoading = false
                self.freezeAccount = response.freeze
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
    
    // MARK: - POST TRACE
    func postTrace(data: DeviceTraceModel, completion: @escaping (Bool) -> Void) {
        ProfileService.shared.trace(data: data) { result in
            switch result {
            case .success(_ ):
                print("Success")
                completion(true)
                
            case .failure(_ ):
                print("ERROR-->")
                completion(false)
            }
        }
    }
}
