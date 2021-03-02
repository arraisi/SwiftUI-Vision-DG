//
//  EncryptPasswordView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/02/21.
//

import SwiftUI
import SwiftyRSA

struct EncryptPasswordView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    @State private var input: String = ""
    @State private var output: String = ""
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")
            
            VStack(alignment: .leading) {
                Text("Input")
                TextField("Input", text: $input)
            }
            
            VStack(alignment: .leading) {
                Text("Encrypted")
                TextField("Encrypted", text: $output)
            }
            
            Button(action: {
                self.encryptPassword()
            }, label: {
                Text("Button")
                    .padding()
            })
            .foregroundColor(.white)
            .background(Color(.blue))
            .cornerRadius(15)
        }
        .padding()
    }
    
    func encryptPassword() {
        let publicKey = try! PublicKey(pemEncoded: AppConstants().PUBLIC_KEY_RSA)
        let clear = try! ClearMessage(string: self.input, using: .utf8)
        
        let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
        _ = encrypted.data
        let base64String = encrypted.base64String
        
        print("Encript : \(base64String)")
        self.output = base64String
        //        self.registerData.password = base64String
    }
}

struct EncryptPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EncryptPasswordView()
    }
}
