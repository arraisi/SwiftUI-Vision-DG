//
//  ActivateKartuKuModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/02/21.
//

import Foundation

class ActivateKartuKuModel: ObservableObject {
    
    @Published var cardNo = ""
    @Published var cvv = ""
    @Published var newPin = ""
    @Published var pinTrx = ""
    
    static let shared = ActivateKartuKuModel()
}
