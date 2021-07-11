//
//  CustomerFromPhoenixResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/05/21.
//

import Foundation

// MARK: - CustomerFromPhoenixResponseElementElement
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
    let kecamatanSuratMenyurat, kelurahanSuratMenyurat: String?
    let rwSuratMenyurat, rtSuratMenyurat: String?
    let alamatSuratMenyurat, provinsiSuratMenyurat, kabupatenSuratMenyurat, kodePosSuratMenyurat: String?
    let penghasilanKotorTahunan, sumberPendapatanLainnya, jumlahSetoranDana, frequencySetoranDana: String?
    let jumlahPenarikanDana, frequencyPenarikanDana, sumberDana: String?
    let tujuanPembukaanRekening: String?
    let namaPerusahaan, hpPerusahaan, alamatPerusahaan, kodePosPerusahaan: String?
    let kecamatanPerusahaan, provinsiPerusahaan, kabupatenPerusahaan, kelurahanPerusahaan: String?
    let teleponPerusahaan: String?
    let keluargaTerdekat, namaKeluargaTerdekat, alamatKeluargaTerdekat, kodePosKeluargaTerdekat: String?
    let kelurahanKeluargaTerdekat, kecamatanKeluargaTerdekat, teleponKeluargaTerdekat: String?
    let pekerjaan: String?
    let bidangUsahaPerusahaan: String?
}

// MARK: - ID
struct IDPhoenix: Codable {
    let surel, telepon: String?
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
