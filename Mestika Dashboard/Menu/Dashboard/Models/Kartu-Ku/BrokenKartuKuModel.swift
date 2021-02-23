//
//  BrokenKartuKuModel.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 23/02/21.
//

import Foundation

class BrokenKartuKuModel: ObservableObject {
    
    @Published var cardNo = ""
    @Published var pin = ""
    
    static let shared = BrokenKartuKuModel()
}
