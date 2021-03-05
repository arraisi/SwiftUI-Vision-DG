//
//  CardBrokenModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/03/21.
//

import Foundation

class CardBrokenModel: ObservableObject {
    
    @Published var addressInput = ""
    @Published var addressRtRwInput = ""
    @Published var addressKelurahanInput = ""
    @Published var addressKecamatanInput = ""
    @Published var addressKodePosInput = ""
    @Published var addressPostalCodeInput = ""
    @Published var atmNumber = ""
    @Published var pinAtm = ""
    
    static let shared = CardBrokenModel()
}
