//
//  VerificationDataPersonalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct VerificationDataPersonalView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var jenisTabungan: String = ""
    @State var tujuanPembukaanRekening: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Image("ic_highfive")
                        .resizable()
                        .frame(width: 95, height: 95)
                        .padding(.top, 40)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Hi, ")
                            .font(.title)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.leading, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Template")
                            .font(.title)
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.trailing, 20)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("You have chosen to register the savings type".localized(language))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .padding(.horizontal, 20)
                        
                        Text("Savings Deposit.".localized(language))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color(hex: "#2334D0"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    }
                    
                    Text("Before continuing the registration process, please first verify the data that you have filled in.".localized(language))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    Group {
                        LabelTextField(value: $jenisTabungan, label: "Types of Savings".localized(language), placeHolder: "Jenis Tabungan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Account Opening Purpose".localized(language), placeHolder: "Account Opening Purpose".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Source of funds".localized(language), placeHolder: "Source of funds".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Profession".localized(language), placeHolder: "Profession".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Position".localized(language), placeHolder: "Position".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Company name".localized(language), placeHolder: "Company name".localized(language)) { (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Company's address".localized(language), placeHolder: "Company's address".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Sub-district".localized(language), placeHolder: "Sub-district".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Village".localized(language), placeHolder: "Village".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Postal code".localized(language), placeHolder: "Postal code".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    Group {
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Company Number".localized(language), placeHolder: "Company Number".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Business fields".localized(language), placeHolder: "Business fields".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Income".localized(language), placeHolder: "Income".localized(language)){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination : VerificationAddressView()) {
                            Text("Valid Data".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            
                        }
                        .frame(height: 40)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                        .padding(.vertical, 20)
                        
                        Button(action : {}) {
                            Text("Valid Data".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            
                        }
                        .frame(height: 40)
                        .background(Color(hex: "#707070"))
                        .cornerRadius(12)
                        .padding(.trailing, 20)
                        .padding(.leading, 5)
                        .padding(.vertical, 20)
                    }
                    
                    Spacer()
                }
                .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.horizontal, 30)
                .padding(.top, 90)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct VerificationDataPersonalView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationDataPersonalView().environmentObject(RegistrasiModel())
    }
}
