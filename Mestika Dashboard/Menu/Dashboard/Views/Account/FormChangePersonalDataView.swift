//
//  FormChangePersonalDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/05/21.
//

import SwiftUI

struct FormChangePersonalDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var profileVM = ProfileViewModel()
    
    @State var nextRoute: Bool = false
    
    var body: some View {
        VStack {
            
            NavigationLink(
                destination: PinConfirmationChangeDataView(),
                isActive: self.$nextRoute,
                label: {EmptyView()}
            )
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Text("Personal Data".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormAddress
                        .padding(.top, 20)
                    
                    Button(action: {
                        self.nextRoute = true
                    }) {
                        Text("Save".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(25)
            }
        }
        .navigationBarTitle("Account", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{profileVM.getProfile(completion: {result in})}
    }
    
    var FormAddress: some View {
        VStack {
            LabelTextField(value: self.$profileVM.name, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.telepon, label: "Telephone".localized(language), placeHolder: "RT".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.email, label: "e-Mail".localized(language), placeHolder: "e-Mail".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.tempatLahir, label: "Place of Birth".localized(language), placeHolder: "Place of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.tglLahir, label: "Date of Birth".localized(language), placeHolder: "Date of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.gender, label: "Gender".localized(language), placeHolder: "Gender".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
}

struct FormChangePersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangePersonalDataView()
    }
}
