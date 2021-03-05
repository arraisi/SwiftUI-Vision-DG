//
//  BrokenKartuKuModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/02/21.
//

import Foundation

class BrokenKartuKuModel: ObservableObject {
    
    @Published var cardDesign = ""
    @Published var nameOnCard = ""
    @Published var addressInput = ""
    @Published var addressRtRwInput = ""
    @Published var addressKelurahanInput = ""
    @Published var addressKecamatanInput = ""
    @Published var addressKodePosInput = ""
    @Published var addressPostalCodeInput = ""
    @Published var cardNo = ""
    @Published var pin = ""
    
    static let shared = BrokenKartuKuModel()
}
