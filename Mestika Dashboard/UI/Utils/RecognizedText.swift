//
//  RecognizedText.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 09/10/20.
//

import Combine
import SwiftUI

final class RecognizedText: ObservableObject, Identifiable {
    
    let willChange = PassthroughSubject<RecognizedText, Never>()
    
    var value: String = "-" {
        willSet {
            willChange.send(self)
        }
    }
    
}
