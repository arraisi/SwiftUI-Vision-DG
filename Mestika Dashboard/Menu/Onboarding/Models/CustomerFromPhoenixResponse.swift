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
    let cdd: Cdd
    let products: [ProductPhoenix]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case customerFromPhoenixResponseID = "id"
        case personal, cdd, products
    }
}

// MARK: - Cdd
struct Cdd: Codable {
    let kecamatanSuratMenyurat, kelurahanSuratMenyurat, rwSuratMenyurat, rtSuratMenyurat: String?
    let alamatSuratMenyurat: String?
    let provinsiSuratMenyurat, kabupatenSuratMenyurat: String?
    let kodePosSuratMenyurat, penghasilanKotorTahunan: String?
    let sumberPendapatanLainnya: String?
    let jumlahSetoranDana, frequencySetoranDana, jumlahPenarikanDana, frequencyPenarikanDana: String?
    let sumberDana, tujuanPembukaanRekening: String
    let namaPerusahaan, hpPerusahaan, alamatPerusahaan, kodePosPerusahaan: String?
    let kecamatanPerusahaan, provinsiPerusahaan, kabupatenPerusahaan, kelurahanPerusahaan: String?
    let teleponPerusahaan, keluargaTerdekat, namaKeluargaTerdekat, alamatKeluargaTerdekat: String?
    let kodePosKeluargaTerdekat, kelurahanKeluargaTerdekat, kecamatanKeluargaTerdekat: String?
    let teleponKeluargaTerdekat: String?
    let pekerjaan, bidangUsahaPerusahaan: String?
}

// MARK: - Citra
struct Citra: Codable {
    let swafoto, ktp: String?
}

// MARK: - ID
struct IDPhoenix: Codable {
    let surel, telepon: String?

    enum CodingKeys: String, CodingKey {
        case surel, telepon
    }
}

// MARK: - Personal
struct PersonalPhoenix: Codable {
    let propName, noProp, kabName, noKab: String?
    let kecName, noKec, kelName, noKel: String?
    let rw, rt, address, marital: String?
    let gender, dateOfBirth, placeOfBirth, name: String?
    let namaIbuKandung: String?
}

// MARK: - Product
struct ProductPhoenix: Codable {
    let planCode: String?
    let accountNo: String?
    let productName: String?
}

typealias CustomerFromPhoenixResponse = [CustomerFromPhoenixResponseElement]
