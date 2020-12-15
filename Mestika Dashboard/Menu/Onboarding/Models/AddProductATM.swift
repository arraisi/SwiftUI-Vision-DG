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
    @Published var atmAddressName: String = ""
    @Published var atmAddresskecamatanInput: String = ""
    @Published var atmAddresskelurahanInput: String = ""
    @Published var atmAddresspostalCodeInput: String = ""
    @Published var atmAddresspostalReferral: String = ""
    @Published var atmAddressrtRwInput: String = ""
    @Published var atmName: String = ""
    @Published var atmDesignType: String = ""
    @Published var productType: String = ""
    @Published var nik: String = ""
    @Published var isNasabahMestika: Bool = false
    @Published var isVcall: Bool = false
    @Published var isAddressEqualToDukcapil: String = ""
    
//    var addressOptionId: Int = 1
    
//    // All your properties should be included
//    enum CodingKeys: String, CodingKey {
//        case atmAddressInput
//        case atmAddressName
//        case atmAddresskecamatanInput
//        case atmAddresskelurahanInput
//        case atmAddresspostalCodeInput
//        case atmAddresspostalReferral
//        case atmAddressrtRwInput
//        case atmDesignName
//        case atmName
//        case productName
//        case addressOptionId
//    }

//    init() {
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        atmAddressInput = try container.decode(String.self, forKey: .atmAddressInput)
//        atmAddressName = try container.decode(String.self, forKey: .atmAddressName)
//        atmAddresskecamatanInput = try container.decode(String.self, forKey: .atmAddresskecamatanInput)
//        atmAddresskelurahanInput = try container.decode(String.self, forKey: .atmAddresskelurahanInput)
//        atmAddresspostalCodeInput = try container.decode(String.self, forKey: .atmAddresspostalCodeInput)
//        atmAddresspostalReferral = try container.decode(String.self, forKey: .atmAddresspostalReferral)
//        atmAddressrtRwInput = try container.decode(String.self, forKey: .atmAddressrtRwInput)
//        atmDesignName = try container.decode(String.self, forKey: .atmDesignName)
//        atmName = try container.decode(String.self, forKey: .atmName)
//        productName = try container.decode(String.self, forKey: .productName)
//        addressOptionId = try container.decode(Int.self, forKey: .addressOptionId)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(atmAddressInput, forKey: .atmAddressInput)
//        try container.encode(atmAddressName, forKey: .atmAddressName)
//        try container.encode(atmAddresskecamatanInput, forKey: .atmAddresskecamatanInput)
//        try container.encode(atmAddresskelurahanInput, forKey: .atmAddresskelurahanInput)
//        try container.encode(atmAddresspostalCodeInput, forKey: .atmAddresspostalCodeInput)
//        try container.encode(atmAddresspostalReferral, forKey: .atmAddresspostalReferral)
//        try container.encode(atmAddressrtRwInput, forKey: .atmAddressrtRwInput)
//        try container.encode(atmDesignName, forKey: .atmDesignName)
//        try container.encode(atmName, forKey: .atmName)
//        try container.encode(productName, forKey: .productName)
//        try container.encode(addressOptionId, forKey: .addressOptionId)
//    }
}
