//
//  Data.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/11/20.
//

import SwiftUI

let cardData: [CardModel] = [
    .init(id: 0, name: "Diamond", description: "", image: Image("atm_diamond")),
    .init(id: 1, name: "Pearl", description: "", image: Image("atm_pearl"))
]

let cardDesainData: [CardModel] = [
    .init(id: 0, name: "THE RED DEVILS CARD", description: "Spesial untuk Anda, para Nasabah bank Mestika yang mencintai klub Manchester United yang berjuluk \"The Red Devils\"", image: Image("atm_bromo")),
    .init(id: 1, name: "BROMO CARD", description: "Spesial untuk Anda, para Nasabah bank Mestika yang mencintai Bromo", image: Image("atm_bromo")),
    .init(id: 2, name: "LAMBORGINI CARD", description: "Spesial untuk Anda, para Nasabah bank Mestika yang mencintai Lamborgini", image: Image("atm_bromo"))
]

let detailJenisATMData: [[DetailATM]] = [[
    .init(id: 1, title: "Penarikan Harian", value: "Rp. 10.000.000,-"),
    .init(id: 2, title: "Transfer Antar Sesama Bank Mestika", value: "Rp. 100.000.000,-"),
    .init(id: 3, title: "Transfer ke Bank Lain", value: "Rp. 25.000.000,-"),
    .init(id: 4, title: "Payment", value: "Rp. 20.000.000,-"),
    .init(id: 5, title: "Purchase", value: "Rp. 25.000.000,-"),
],
[
    .init(id: 1, title: "Penarikan Harian", value: "Rp. 5.000.000,-"),
    .init(id: 2, title: "Transfer Antar Sesama Bank Mestika", value: "Rp. 50.000.000,-"),
    .init(id: 3, title: "Transfer ke Bank Lain", value: "Rp. 15.000.000,-"),
    .init(id: 4, title: "Payment", value: "Rp. 10.000.000,-"),
    .init(id: 5, title: "Purchase", value: "Rp. 15.000.000,-"),
],
[
    .init(id: 1, title: "Penarikan Harian", value: "Rp. 5.000.000,-"),
    .init(id: 2, title: "Transfer Antar Sesama Bank Mestika", value: "Rp. 50.000.000,-"),
    .init(id: 3, title: "Transfer ke Bank Lain", value: "Rp. 15.000.000,-"),
    .init(id: 4, title: "Payment", value: "Rp. 10.000.000,-"),
    .init(id: 5, title: "Purchase", value: "Rp. 15.000.000,-"),
],
[
    .init(id: 1, title: "Penarikan Harian", value: "Rp. 5.000.000,-"),
    .init(id: 2, title: "Transfer Antar Sesama Bank Mestika", value: "Rp. 50.000.000,-"),
    .init(id: 3, title: "Transfer ke Bank Lain", value: "Rp. 15.000.000,-"),
    .init(id: 4, title: "Payment", value: "Rp. 10.000.000,-"),
    .init(id: 5, title: "Purchase", value: "Rp. 15.000.000,-"),
],
[
    .init(id: 1, title: "Penarikan Harian", value: "Rp. 5.000.000,-"),
    .init(id: 2, title: "Transfer Antar Sesama Bank Mestika", value: "Rp. 50.000.000,-"),
    .init(id: 3, title: "Transfer ke Bank Lain", value: "Rp. 15.000.000,-"),
    .init(id: 4, title: "Payment", value: "Rp. 10.000.000,-"),
    .init(id: 5, title: "Purchase", value: "Rp. 15.000.000,-"),
]]

let myCardData: [MyCard] = load("myCardData.json")
let savingTypeData: [SavingType] = load("savingTypeData.json")
let masterData: [MasterModel] = load("masterData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
