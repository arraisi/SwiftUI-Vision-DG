//
//  FormChangeContactView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI
import LocalAuthentication

struct FormChangeContactView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var txtPhone: String = ""
    @State private var txtEmail: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Contact Data")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(Color(hex: "#2334D0"))
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text("Phone")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(.black)
                        
                        TextField(NSLocalizedString("Input Number Phone", comment: ""), text: $txtPhone, onEditingChanged: { changed in
                            
                        })
                        .font(.custom("Montserrat-Regular", size: 12))
                        .keyboardType(.numberPad)
                        .padding(15)
                        .background(Color.gray.opacity(0.1))
                        .frame(height: 50)
                        .cornerRadius(20)
                    }
                    .padding(.top, 15)
                    
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(.black)
                        
                        TextField(NSLocalizedString("Input Email", comment: ""), text: $txtEmail, onEditingChanged: { changed in
                            
                        })
                        .font(.custom("Montserrat-Regular", size: 12))
                        .keyboardType(.numberPad)
                        .padding(15)
                        .background(Color.gray.opacity(0.1))
                        .frame(height: 50)
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        //                    self.showModal = false
                    }) {
                        Text("Back")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    }
                    .padding()
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    .padding(.top, 30)
                    
                }
                .padding(.top)
                
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(25)
            .padding(.top, 30)
            
        }
        .navigationBarTitle("Akun", displayMode: .inline)
    }
}

struct FormChangeContactView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeContactView()
    }
}
