//
//  AddATMModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 24/11/20.
//

import Combine
import Foundation

class AddProductATM: ObservableObject, Codable {
    @Published var atmAddressInput: String = ""
    @Published var imageDesign: String = ""
    @Published var codeClass: String = ""
    @Published var atmAddressName: String = ""
    @Published var atmAddressKecamatanInput: String = ""
    @Published var atmAddressKelurahanInput: String = ""
    @Published var atmAddressKotaInput: String = ""
    @Published var atmAddressPropinsiInput: String = ""
    @Published var atmAddressPostalCodeInput: String = ""
    @Published var atmAddresspostalReferral: String = ""
    @Published var atmAddressrtRwInput: String = ""
    @Published var atmAddressRtInput: String = ""
    @Published var atmAddressRwInput: String = ""
    @Published var atmName: String = ""
    @Published var atmDesignType: String = ""
    @Published var productType: String = ""
    @Published var nik: String = ""
    @Published var isNasabahMestika: Bool = false
    @Published var isVcall: Bool = false
    @Published var addressEqualToDukcapil: Bool = false
}
