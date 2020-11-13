//
//  OTPTextField.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI

struct OTPTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @Binding var currentlySelectedCell: Int

        var didBecomeFirstResponder = false

        init(text: Binding<String>, currentlySelectedCell: Binding<Int>) {
            _text = text
            _currentlySelectedCell = currentlySelectedCell
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""

            guard let stringRange = Range(range, in: currentText) else { return false }

            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            if updatedText.count <= 1 {
                self.currentlySelectedCell += 1
            }

            return updatedText.count <= 1
        }
    }

    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<OTPTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.font = .systemFont(ofSize: 24, weight: .bold)
        return textField
    }

    func makeCoordinator() -> OTPTextField.Coordinator {
        return Coordinator(text: $text, currentlySelectedCell: $currentlySelectedCell)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<OTPTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
