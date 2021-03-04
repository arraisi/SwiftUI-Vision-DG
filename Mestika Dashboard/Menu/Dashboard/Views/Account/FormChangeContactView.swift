//
//  FormChangeContactView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI
import LocalAuthentication

struct FormChangeContactView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var txtPhone: String
    @Binding var txtEmail: String
    
    var body: some View {
        VStack {
            AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {
                
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Contact Data".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            Text("Phone Number".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(.black)
                            
                            HStack{
                                Text("+62")
                                Divider()
                                TextField("Input Number Phone".localized(language), text: $txtPhone, onEditingChanged: { changed in
                                    
                                })
                                
                            }
                            .disabled(true)
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
                            
                            TextField("Input Email", text: $txtEmail, onEditingChanged: { changed in
                                
                            })
                            .disabled(true)
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
                            Text("Back".localized(language))
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
//                    .padding(.top)
                    
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(25)
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct FormChangeContactView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeContactView(txtPhone: .constant(""), txtEmail: .constant(""))
    }
}
