//
//  CharacterInputCell.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI

struct CharacterInputCell: View {
    @State private var textValue: String = ""
    @Binding var currentlySelectedCell: Int

    var index: Int

    var responder: Bool {
        return index == currentlySelectedCell
    }

    var body: some View {
        OTPTextField(text: $textValue, currentlySelectedCell: $currentlySelectedCell, isFirstResponder: responder)
            .frame(width: 40, height: 40)
            .font(Font.title2.bold())
            .foregroundColor(Color(hex: "#232175"))
            .multilineTextAlignment(.center)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
    }
}
