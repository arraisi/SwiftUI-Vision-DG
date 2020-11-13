//
//  TextFieldWithToolBarKeyBoard.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 06/11/20.
//

import SwiftUI

struct TextFieldWithToolBarKeyBoard: UIViewRepresentable {
    @Binding var text: String
    
    var keyType: UIKeyboardType
    
    func makeUIView(context: Context) -> UITextField {
        
        let textfield = UITextField()
        
        textfield.delegate = context.coordinator
        textfield.keyboardType = keyType
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldWithToolBarKeyBoard
        
        init(_ textField: TextFieldWithToolBarKeyBoard) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string) as String
                self.parent.text = proposedValue
            }
            return true
        }
        
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        self.resignFirstResponder()
    }
    
}
