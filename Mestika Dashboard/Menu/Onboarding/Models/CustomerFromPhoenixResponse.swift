//
//  CustomerFromPhoenixResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/05/21.
//

import Foundation

// MARK: - CustomerFromPhoenixResponseElement
struct CustomerFromPhoenixResponseElement: Codable {
    let id: String
    let customerFromPhoenixResponseID: IDPhoenix
    let personal: PersonalPhoenix
    let citra: Citra
    let cdd: Cdd
    let products: [ProductPhoenix]
    let resikoProfil: ResikoProfil
    let pepOpsi: Bool
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customerFromPhoenixResponseID = "id"
        case personal, citra, cdd, products, resikoProfil, pepOpsi, status
    }
}

// MARK: - Cdd
struct Cdd: Codable {
    let kecamatanSuratMenyurat, kelurahanSuratMenyurat, rwSuratMenyurat, rtSuratMenyurat, kabupatenSuratMenyurat, provinsiSuratMenyurat, kodePosSuratMenyurat: String?
    let alamatSuratMenyurat: String?
    let penghasilanKotorTahunan, sumberPendapatanLainnya: String?
    let jumlahSetoranDana, frequencySetoranDana, jumlahPenarikanDana, frequencyPenarikanDana: String?
    let sumberDana, tujuanPembukaanRekening, namaPerusahaan: String?
    let hpPerusahaan: String?
    let alamatPerusahaan, kodePosPerusahaan, kecamatanPerusahaan, kelurahanPerusahaan: String?
    let teleponPerusahaan, keluargaTerdekat: String?
    let namaKeluargaTerdekat, alamatKeluargaTerdekat, kodePosKeluargaTerdekat, kelurahanKeluargaTerdekat: String?
    let kecamatanKeluargaTerdekat, teleponKeluargaTerdekat, pekerjaan: String?
    let bidangUsahaPerusahaan: String?
}

// MARK: - Citra
struct Citra: Codable {
    let swafoto, ktp: String?
}

// MARK: - ID
struct IDPhoenix: Codable {
    let surel, telepon, nik, firebaseID: String?
    let firebaseToken, deviceID, cif: String?

    enum CodingKeys: String, CodingKey {
        case surel, telepon, nik
        case firebaseID = "firebaseId"
        case firebaseToken
        case deviceID = "deviceId"
        case cif
    }
}

// MARK: - Personal
struct PersonalPhoenix: Codable {
    let propName, noProp, kabName, noKab: String?
    let kecName, noKec, kelName, noKel: String?
    let rw, rt, address, marital: String?
    let gender, dateOfBirth, placeOfBirth, name: String?
    let namaIbuKandung: String?
    let existingCustomer: Bool?
}

// MARK: - Product
struct ProductPhoenix: Codable {
    let planCode: String?
    let accountNo: String?
    let productName: String?
}

// MARK: - ResikoProfil
struct ResikoProfil: Codable {
    let resikoIdentitas, resikoProfil, resikoKegiatanUsaha, resikoLokasiUsaha: String?
    let resikoStrukturKepemilikan, resikoProdukJasa, resikoJumlahTransaksi, resikoLainnya: String?
}

typealias CustomerFromPhoenixResponse = [CustomerFromPhoenixResponseElement]
