//
//  AppState.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 24/11/20.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var moveToWelcomeView: Bool = false
    @Published var moveToDashboard: Bool = false
    @Published var skipOTP: Bool = false
    @Published var nasabahIsExisting: Bool = false
    @Published var moveToWelcomeViewThenCancel: Bool = false
    
    var navigationController: UINavigationController?
}
