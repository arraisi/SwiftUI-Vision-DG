//
//  FormChangeOtherDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/05/21.
//

import SwiftUI

struct FormChangeOtherDataView: View {
    
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
            
            AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {
                
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Text("Data Pembuatan Rekening".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormPembuatanRekening
                        .padding(.top, 20)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
                
                VStack {
                    
                    Text("Data Keluarga".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormKeluargaTerdekat
                        .padding(.top, 20)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
                
                VStack {
                    
                    Text("Data Pekerjaan".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormPekerjaan
                        .padding(.top, 20)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
                
                VStack {
                    
                    Text("Data Penyandang Dana".localized(language))
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormPenyandangDana
                        .padding(.top, 20)
                }
                .padding(30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
                
                VStack {
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
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back".localized(language))
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.top, 10)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            
            profileVM.getProfile(completion: {result in})
            profileVM.getCustomerFromPhoenix(completion: {result in})
            
        }
    }
    
    var FormPembuatanRekening: some View {
        VStack {
            LabelTextField(value: self.$profileVM.tujuanPembukaan, label: "Tujuan Pembukaan".localized(language), placeHolder: "Tujuan Pembukaan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.sumberDana, label: "Sumber Dana".localized(language), placeHolder: "Sumber Dana".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.jumlahPenarikanPerbulan, label: "Jumlah Penarikan Perbulan".localized(language), placeHolder: "Jumlah Penarikan Perbulan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.jumlahPenarikanDanaPerbulan, label: "Jumlah Penarikan Dana Perbulan".localized(language), placeHolder: "Jumlah Penarikan Dana Perbulan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.jumlahSetoranPerbulan, label: "Jumlah Setoran Perbulan".localized(language), placeHolder: "umlah Setoran Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.jumlahSetoranDanaPerbulan, label: "umlah Setoran Dana Perbulan".localized(language), placeHolder: "umlah Setoran Dana Perbulan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
    
    var FormKeluargaTerdekat: some View {
        VStack {
            LabelTextField(value: self.$profileVM.hubunganKeluarga, label: "Hubungan Keluarga".localized(language), placeHolder: "Hubungan Keluarga".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.namaKeluarga, label: "Nama".localized(language), placeHolder: "Nama".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.alamatKeluarga, label: "Alamat".localized(language), placeHolder: "Alamat".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.kodePosKeluarga, label: "Kode Pos".localized(language), placeHolder: "Kode Pos".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.kelurahanKeluarga, label: "Kelurahan".localized(language), placeHolder: "Kelurahan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.kecamatanKeluarga, label: "Kecamatan".localized(language), placeHolder: "Kecamatan".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.teleponKeluarga, label: "Telepon".localized(language), placeHolder: "Telepon".localized(language), disabled: false, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
    
    var FormPekerjaan: some View {
        VStack {
            LabelTextField(value: self.$profileVM.pekerjaan, label: "Pekerjaan".localized(language), placeHolder: "Pekerjaan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.penghasilanKotor, label: "Penghasilan Kotor".localized(language), placeHolder: "Penghasilan Kotor".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.PendapatanLainnya, label: "Pendapatan Lainnya".localized(language), placeHolder: "Pendapatan Lainnya".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
    
    var FormPenyandangDana: some View {
        VStack {
            LabelTextField(value: self.$profileVM.namaPenyandang, label: "Nama".localized(language), placeHolder: "Nama".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.hubunganPenyandang, label: "Hubungan".localized(language), placeHolder: "Hubungan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.pekerjaanPenyandang, label: "Pekerjaan".localized(language), placeHolder: "Pekerjaan".localized(language), disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
}

struct FormChangeOtherDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeOtherDataView()
    }
}
