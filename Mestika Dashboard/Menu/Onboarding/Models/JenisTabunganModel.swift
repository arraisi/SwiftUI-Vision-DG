// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let jenisTabunganModel = try? newJSONDecoder().decode(JenisTabunganModel.self, from: jsonData)

import Foundation

//// MARK: - JenisTabunganModel
//struct JenisTabunganModel: Codable {
//    let content: [ContentJenisTabungan]
//}
//
//// MARK: - Content
//struct ContentJenisTabungan: Codable {
//    let id, name: String
//    let image: String
//    let contentDescription, type, codePlan: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, image
//        case contentDescription = "description"
//        case type, codePlan
//    }
//}

// MARK: - JenisTabunganModelElement
struct JenisTabunganModelElement: Codable {
    let id, kodePlan, kodeAplikasi: String
    let balType: String?
    let namaPlan, currency: String
    let outgoing, continueFlag: String?
    let minimumSaldo, biayaAdministrasi, minimumSetoranAwal, minimumSetoranSelanjutnya: String
    let fieldRate1, fieldRate2, fieldRate3, fieldRate4: String
    let fieldRate5, fieldRate6, fieldRate7, fieldRate8: String
    let fieldRate9: String?
    let fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4: String
    let fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8: String
    let fieldSaldo9: String?
    let productName, productDescription: String
    let productImageURL: String
    let categoryProduct: String
    let enable: Bool?

    enum CodingKeys: String, CodingKey {
        case id, kodePlan, kodeAplikasi, balType, namaPlan, currency, outgoing, continueFlag, minimumSaldo, biayaAdministrasi, minimumSetoranAwal, minimumSetoranSelanjutnya, fieldRate1, fieldRate2, fieldRate3, fieldRate4, fieldRate5, fieldRate6, fieldRate7, fieldRate8, fieldRate9, fieldSaldo1, fieldSaldo2, fieldSaldo3, fieldSaldo4, fieldSaldo5, fieldSaldo6, fieldSaldo7, fieldSaldo8, fieldSaldo9, productName, productDescription
        case productImageURL = "productImageUrl"
        case categoryProduct, enable
    }
}

typealias JenisTabunganModel = [JenisTabunganModelElement]
