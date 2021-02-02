//
//  TransferOnUsModel.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 02/02/21.
//

import Foundation

class TransferOnUsModel: ObservableObject {
    @Published var cardNo = ""
    @Published var ref = "1"
    @Published var nominal = ""
    @Published var currency = "360"
    @Published var sourceNumber = ""
    @Published var destinationNumber = ""
    @Published var berita = ""
    @Published var pin = ""
    
    static let shared = TransferOnUsModel()
}
