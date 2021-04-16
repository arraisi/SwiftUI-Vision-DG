//
//  ScannerViewModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 16/04/21.
//

import Foundation

class ScannerViewModel: ObservableObject {
    
    /// Defines how often we are going to try looking for a new QR-code in the camera feed.
    let scanInterval: Double = 1.0
    
    @Published var barcodeFounded: Bool = false
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = ""
    
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        print("\nCode : \(self.lastQrCode)\n")
    }
}
