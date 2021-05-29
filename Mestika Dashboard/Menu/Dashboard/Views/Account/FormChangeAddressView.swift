//
//  FormChangeAddressView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI

struct FormChangeAddressView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var profileVM = ProfileViewModel()
    
    @State var nextRoute: Bool = false
    
    @Binding var alamat: String
    @Binding var kelurahan: String
    @Binding var kecamatan: String
    @Binding var kabKota: String
    @Binding var provinsi: String
    
    @Binding var alamatMailing: String
    @Binding var kodePosMailing: String
    @Binding var kelurahanMailing: String
    @Binding var kecamatanMailing: String
    @Binding var kabKotaMailing: String
    @Binding var provinsiMailing: String
    
    var body: some View {
        VStack {
            
            NavigationLink(
                destination: PinConfirmationChangeDataView(),
                isActive: self.$nextRoute,
                label: {EmptyView()}
            )
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    FormAddress
                    
                    
                    FormAddressMailing
                    
                    VStack(spacing: 10) {
                        if !self.profileVM.existingCustomer {
                            Button(action: {
                                
                                self.profileVM.updateCustomerPhoenix { (isSuccess) in
                                    
                                }
                                
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
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 25)
            }
        }
        .navigationBarTitle("Address", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
    
    var FormAddress: some View {
        VStack {
            
            Text("Mailing Address Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
            
            VStack {
                LabelTextField(value: self.$alamat, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kelurahan, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kecamatan, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kabKota, label: "City".localized(language), placeHolder: "City".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$provinsi, label: "Province".localized(language), placeHolder: "Province".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
            .padding(.top, 20)
            
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
    }
    
    var FormAddressMailing: some View {
        VStack {
            
            Text("Address Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
            
            VStack {
                LabelTextField(value: self.$alamatMailing, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kodePosMailing, label: "Postal Code".localized(language), placeHolder: "Postal Code".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kelurahanMailing, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kecamatanMailing, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kabKotaMailing, label: "City".localized(language), placeHolder: "City".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$provinsiMailing, label: "Province".localized(language), placeHolder: "Province".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
            .padding(.top, 20)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
    }
}

struct FormChangeAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormChangeAddressView(alamat: .constant(""), kelurahan: .constant(""), kecamatan: .constant(""), kabKota: .constant(""), provinsi: .constant(""), alamatMailing: .constant(""), kodePosMailing: .constant(""), kelurahanMailing: .constant(""), kecamatanMailing: .constant(""), kabKotaMailing: .constant(""), provinsiMailing: .constant(""))
        }
    }
}
