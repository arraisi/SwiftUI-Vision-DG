//
//  BiometricType.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI
import LocalAuthentication

struct Biometric {
    
    //Mark: For select type of your biometric
    enum BiometricType {
        case touchID
        case faceID
        case none
    }
    
    // Create func that detect your device.
    func type() -> BiometricType {
        
        let authenticationContext = LAContext()
        _ = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch (authenticationContext.biometryType){
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
}

