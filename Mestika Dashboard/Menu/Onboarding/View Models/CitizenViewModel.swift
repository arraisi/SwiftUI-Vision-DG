//
//  CitizenViewModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation
import Combine

class CitizenViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var nik: String = ""
    @Published var channel: String = ""
    @Published var agenId: String = ""
    @Published var workstation: String = ""
    @Published var nomorKk: String = ""
    @Published var namaLengkap: String = ""
    @Published var jenisKelamin: String = ""
    @Published var tempatLahir: String = ""
    @Published var tanggalLahir: String = ""
    @Published var agama: String = ""
    @Published var statusPerkawinan: String = ""
    @Published var pendidikan: String = ""
    @Published var jenisPekerjaan: String = ""
    @Published var namaIbu: String = ""
    @Published var statusHubungan: String = ""
    @Published var alamatKtp: String = ""
    @Published var rt: String = ""
    @Published var rw: String = ""
    @Published var kelurahan: String = ""
    @Published var kecamatan: String = ""
    @Published var kabupatenKota: String = ""
    @Published var provinsi: String = ""
    @Published var errorMessage: String = ""
}

extension CitizenViewModel {
    
    // MARK: - GET CITIZEN
    func getCitizen(nik: String, completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        CitizenService.shared.checkNIK(nik: nik) { result in
            switch result {
            case .success(let response):
                print("Success")
                print(response.nik)
                
                self.isLoading = false
                self.nik = response.nik ?? ""
                self.namaLengkap = response.namaLengkap ?? ""
                self.alamatKtp = response.alamatKtp ?? ""
                self.kelurahan = response.kelurahan ?? ""
                self.errorMessage = "VALID"
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 404):
                    self.errorMessage = "Nik tidak terdaftar"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}