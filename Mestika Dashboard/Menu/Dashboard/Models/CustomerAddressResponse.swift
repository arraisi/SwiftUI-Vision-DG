// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let customerAddressResponse = try? newJSONDecoder().decode(CustomerAddressResponse.self, from: jsonData)

import Foundation

// MARK: - CustomerAddressResponseElement
struct CustomerAddressResponseElement: Codable {
    let ktpAddress: KtpAddress
    let mailingAddress: MailingAddress
    let companyAddress: CompanyAddress
}

// MARK: - CompanyAddress
struct CompanyAddress: Codable {
    let namaPerusahaan, hpPerusahaan, alamatPerusahaan, kodePosPerusahaan: String?
    let kecamatanPerusahaan, provinsiPerusahaan, kabupatenPerusahaan, kelurahanPerusahaan: String?
    let teleponPerusahaan: String?
}

// MARK: - KtpAddress
struct KtpAddress: Codable {
    let propName, kabName, kecName, kelName: String?
    let rw, rt: String?
    let address, name: String?
}

// MARK: - MailingAddress
struct MailingAddress: Codable {
    let kecamatanSuratMenyurat, kelurahanSuratMenyurat: String?
    let rwSuratMenyurat, rtSuratMenyurat: String?
    let alamatSuratMenyurat, provinsiSuratMenyurat, kabupatenSuratMenyurat, kodePosSuratMenyurat: String?
}

typealias CustomerAddressResponse = [CustomerAddressResponseElement]
