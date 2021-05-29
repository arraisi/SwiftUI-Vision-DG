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
    
    @State var nextRoute: Bool = false
    
    @ObservedObject var profileVM = ProfileViewModel()
    
    @Binding var name: String
    @Binding var phone: String
    @Binding var email: String
    @Binding var placeOfBirth: String
    @Binding var dateOfBirth: String
    @Binding var gender: String
    
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
                        .padding()
                    
                    VStack {
                        LabelTextField(value: self.$name, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: false, onEditingChanged: { (Bool) in
                            print("on edit")
                        }, onCommit: {
                            print("on commit")
                        })
                        
                        LabelTextField(value: self.$phone, label: "Telephone".localized(language), placeHolder: "Telephone".localized(language), disabled: false, onEditingChanged: { (Bool) in
                            print("on edit")
                        }, onCommit: {
                            print("on commit")
                        })
                        
                        LabelTextField(value: self.$email, label: "e-Mail".localized(language), placeHolder: "e-Mail".localized(language), disabled: false, onEditingChanged: { (Bool) in
                            print("on edit")
                        }, onCommit: {
                            print("on commit")
                        })
                        
                        LabelTextField(value: self.$placeOfBirth, label: "Place of Birth".localized(language), placeHolder: "Place of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                            print("on edit")
                        }, onCommit: {
                            print("on commit")
                        })
                        
                        //                LabelTextField(value: self.$dateOfBirth, label: "Date of Birth".localized(language), placeHolder: "Date of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                        //                    print("on edit")
                        //                }, onCommit: {
                        //                    print("on commit")
                        //                })
                        
                        LabelTextFieldMenu(value: self.$gender, label: "Gender", data: ["Laki-laki", "Perempuan"], onEditingChanged: {_ in}, onCommit: {})
                        
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
                        .padding(.top, 15)
                    }
                }
                .padding(25)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 25)
                .padding(.top, 30)
                
                
                //                VStack(spacing: 20) {
                //                    PersonalData(name: $profileVM.name, phone: $profileVM.telepon, email: $profileVM.email, placeOfBirth: $profileVM.tempatLahir, dateOfBirth: $profileVM.tglLahir, gender: $profileVM.gender)
                //                        .padding(.top, 20)
                //
                //                    PembukaanRekeningData(tujuanBukaRek: $profileVM.tujuanPembukaan, sumberDana: $profileVM.sumberDana, penarikanPerbulan: $profileVM.jumlahPenarikanPerbulan, danaPenarikanPerbulan: $profileVM.jumlahPenarikanDanaPerbulan, setoranPerbulan: $profileVM.jumlahSetoranPerbulan, danaSetoranPerbulan: $profileVM.jumlahSetoranDanaPerbulan)
                //
                //                    PekerjaanData(pekerjaan: $profileVM.pekerjaan, pengahasilanKotor: $profileVM.penghasilanKotor, pendapatanLainnya: $profileVM.PendapatanLainnya)
                //
                //                    PerusahaanData(nama: $profileVM.namaPerusahaan, alamat: $profileVM.alamatPerusahaan, kodePos: $profileVM.kodePosPerusahaan, kelurahan: $profileVM.kelurahanPerusahaan, kecamatan: $profileVM.kecamatanPerusahaan, telepon: $profileVM.teleponPerusahaan)
                //
                
                //                }
            }
        }
        .navigationBarTitle("Account", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
}

struct FormChangePersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormChangePersonalDataView(name: .constant(""), phone: .constant(""), email: .constant(""), placeOfBirth: .constant(""), dateOfBirth: .constant(""), gender: .constant(""))
        }
    }
}
