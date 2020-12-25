//
//  AddressSugestionResponse.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 25/12/20.
//

import Foundation

// MARK: - OtpResponse
struct AddressSugestionResponse: Decodable {
    let formatted_address, streetNumber, placeName: String
    let street: String
    let rt: String
    let rw: String
    let wilayah: String
    let kelurahan: String
    let kecamatan: String
    let city: String
    let province: String
    let country: String
    let postalCode: String
}
