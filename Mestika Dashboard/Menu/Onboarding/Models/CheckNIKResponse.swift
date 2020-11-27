//
//  CheckNIKResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/11/20.
//

import Foundation

struct CheckNIKResponse: Decodable {
    let nik, channel, agenId, workstation: String?
    let nomorKk: String?
    let namaLengkap, jenisKelamin, tempatLahir, tanggalLahir: String?
    let agama, statusPerkawinan, pendidikan, jenisPekerjaan: String?
    let namaIbu, statusHubungan, alamatKtp, rt: String?
    let rw, kelurahan, kecamatan, kabupatenKota: String?
    let provinsi, errorMessage: String?
    let code, message: String?
}
