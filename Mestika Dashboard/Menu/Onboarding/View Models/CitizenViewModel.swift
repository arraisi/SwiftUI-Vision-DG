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
    func getCitizen(
        nik: String,
        phone: String,
        isNasabah: Bool,
        alamat: String,
        jenisKelamin: String,
        kecamatan: String,
        kelurahan: String,
        kewarganegaraan: String,
        nama: String,
        namaIbu: String,
        rt: String,
        rw: String,
        statusKawin: String,
        tanggalLahir: String,
        tempatLahir: String,
        provinsi: String,
        kota: String,
        completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        CitizenService.shared.checkNIK(
            nik: nik,
            phone: phone,
            isNasabah: isNasabah,
            alamat: alamat,
            jenisKelamin: jenisKelamin,
            kecamatan: kecamatan,
            kelurahan: kelurahan,
            kewarganegaraan: kewarganegaraan,
            nama: nama,
            namaIbu: namaIbu,
            rt: rt,
            rw: rw,
            statusKawin: statusKawin,
            tanggalLahir: tanggalLahir,
            tempatLahir: tanggalLahir,
            provinsi: provinsi,
            kota: kota) { result in
            
            switch result {
            case .success(let response):
                print("Success")
                
                self.isLoading = false
                self.nik = response.nik ?? ""
                self.namaLengkap = response.namaLengkap ?? ""
                self.alamatKtp = response.alamatKtp ?? ""
                self.kelurahan = response.kelurahan ?? ""
                self.kecamatan = response.kecamatan ?? ""
                self.kabupatenKota = response.kabupatenKota ?? ""
                self.provinsi = response.provinsi ?? ""
                self.errorMessage = "VALID"
                completion(true)
                
            case .failure(let error):
                print("ERROR-->")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                switch error {
                case .custom(code: 401):
                    self.errorMessage = "Token Expired"
                case .custom(code: 404):
                    self.errorMessage = "NIK TIDAK TERDAFTAR"
                case .custom(code: 403):
                    self.errorMessage = "NIK tidak dapat didaftarkan untuk pembukaan rekening"
                default:
                    self.errorMessage = "Internal Server Error"
                }
                completion(false)
            }
        }
    }
}
