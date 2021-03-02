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
                        
                        Text(NSLocalizedString("Template", comment: ""))
                            .font(.title)
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.trailing, 20)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("You have chosen to register the savings type".localized(language), comment: ""))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .padding(.horizontal, 20)
                        
                        Text(NSLocalizedString("Savings Deposit.".localized(language), comment: ""))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color(hex: "#2334D0"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    }
                    
                    Text(NSLocalizedString("Before continuing the registration process, please first verify the data that you have filled in.".localized(language), comment: ""))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    Group {
                        LabelTextField(value: $jenisTabungan, label: NSLocalizedString("Types of Savings".localized(language), comment: ""), placeHolder: NSLocalizedString("Jenis Tabungan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Account Opening Purpose".localized(language), comment: ""), placeHolder: NSLocalizedString("Account Opening Purpose".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Source of funds".localized(language), comment: ""), placeHolder: NSLocalizedString("Source of funds".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Profession".localized(language), comment: ""), placeHolder: NSLocalizedString("Profession".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Position".localized(language), comment: ""), placeHolder: NSLocalizedString("Position".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Company name".localized(language), comment: ""), placeHolder: NSLocalizedString("Company name".localized(language), comment: "")) { (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Company's address".localized(language), comment: ""), placeHolder: NSLocalizedString("Company's address".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Sub-district".localized(language), comment: ""), placeHolder: NSLocalizedString("Sub-district".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Village".localized(language), comment: ""), placeHolder: NSLocalizedString("Village".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Postal code".localized(language), comment: ""), placeHolder: NSLocalizedString("Postal code".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    Group {
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Company Number".localized(language), comment: ""), placeHolder: NSLocalizedString("Company Number".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Business fields".localized(language), comment: ""), placeHolder: NSLocalizedString("Business fields".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Income".localized(language), comment: ""), placeHolder: NSLocalizedString("Income".localized(language), comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination : VerificationAddressView()) {
                            Text(NSLocalizedString("Valid Data".localized(language), comment: ""))
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
                            Text(NSLocalizedString("Valid Data".localized(language), comment: ""))
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
