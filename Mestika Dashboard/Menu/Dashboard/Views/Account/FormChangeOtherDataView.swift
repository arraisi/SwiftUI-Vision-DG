//
//  FormChangeOtherDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/05/21.
//

import SwiftUI
import Indicators

struct FormChangeOtherDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var nextRoute: Bool = false
    @State private var isLoading: Bool = false
    
    @Binding var namaPenyandangDana: String
    @Binding var tujuanPembukaan: String
    @Binding var sumberDana: String
    @Binding var frekuensiPenarikanPerbulan: String
    @Binding var jumlahPenarikanPerbulan: String
    @Binding var frekuensiSetoranPerbulan: String
    @Binding var jumlahSetoranPerbulan: String
    
    @Binding var pekerjaan: String
    @Binding var penghasilanKotor: String
    @Binding var otherIncome: String
    
    @Binding var namaPerusahaan: String
    @Binding var alamatPerusahaan: String
    @Binding var kodePosPerusahaan: String
    @Binding var kelurahanPerusahaan: String
    @Binding var kecamatanPerusahaan: String
    @Binding var kabKotaPerusahaan: String
    @Binding var provinsiPerusahaan: String
    @Binding var teleponPerusahaan: String
    
    let tujuanPembukaanRekeningData: [MasterModel] = load("tujuanPembukaanRekening.json")
    let sumberDanaData: [MasterModel] = load("sumberDana.json")
    let perkiraanPenarikanData: [MasterModel] = load("perkiraanSetoran.json")
    let besarPerkiraanPenarikanData: [MasterModel] = load("besarPerkiraanSetoran.json")
    let perkiraanSetoranData: [MasterModel] = load("perkiraanSetoran.json")
    let besarPerkiraanSetoranData: [MasterModel] = load("besarPerkiraanSetoran.json")
    let pekerjaanData: [MasterModel] = load("pekerjaan.json")
    let penghasilanKotorData: [MasterModel] = load("penghasilanKotor.json")
    let otherIncomeData = ["Online Shop", "Cathering", "Laundry pakaian", "Sosial media buzzer", "Jual aneka kue", "Lainnya"]
    
    var body: some View {
        VStack {
            
            NavigationLink(
                destination: PinConfirmationChangeDataView(),
                isActive: self.$nextRoute,
                label: {EmptyView()}
            )
            
            ScrollView(showsIndicators: false) {
                VStack {
                    FormPembuatanRekening
                    
                    
                    if (self.namaPerusahaan == "") {
                        EmptyView()
                    } else {
                        FormPekerjaan
                        
                        FormPerusahaan
                    }
                    
//                    if (self.namaPenyandangDana == "") {
//                        EmptyView()
//                    } else {
//                        FormPenyandangDana
//                    }
                    
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
                        .padding(.vertical, 30)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 20)
                }
                .padding(.top, 20)
            }
        }
        .navigationBarTitle("Other Data", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
    
    // MARK: FORM PEMBUKAAN REKENING
    var FormPembuatanRekening: some View {
        VStack {
            
            Text("Account Opening Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            
            VStack {
                LabelTextFieldMenu(value: self.$tujuanPembukaan, label: "Opening Purpose".localized(language), data: tujuanPembukaanRekeningData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$sumberDana, label: "Source of funds".localized(language), data: sumberDanaData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$frekuensiPenarikanPerbulan, label: "Monthly witdrawal".localized(language), data: perkiraanPenarikanData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$jumlahPenarikanPerbulan, label: "Monthly witdrawal amount".localized(language), data: besarPerkiraanPenarikanData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$frekuensiSetoranPerbulan, label: "Monthly deposit".localized(language), data: perkiraanSetoranData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$jumlahSetoranPerbulan, label: "Monthly deposit amount".localized(language), data: besarPerkiraanSetoranData.map{$0.name}, onEditingChanged: { (Bool) in
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
        .padding(.horizontal, 25)
        .padding(.bottom, 10)
    }
    
    // MARK: FORM PEKERJAAN
    var FormPekerjaan: some View {
        VStack {
            
            Text("Occupation Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
            
            VStack {
                LabelTextFieldMenu(value: self.$pekerjaan, label: "Occupation".localized(language), data: pekerjaanData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$penghasilanKotor, label: "Gross income".localized(language), data: penghasilanKotorData.map{$0.name}, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$otherIncome, label: "Other income".localized(language), data: otherIncomeData, onEditingChanged: { (Bool) in
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
        .padding(.horizontal, 25)
        .padding(.bottom, 10)
    }
    
    // MARK: FORM PERUSHAAN
    var FormPerusahaan: some View {
        
        VStack {
            
            Text("Company Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
            
            VStack {
                LabelTextField(value: self.$namaPerusahaan, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$alamatPerusahaan, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kodePosPerusahaan, label: "Postal Code".localized(language), placeHolder: "Postal Code".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kelurahanPerusahaan, label: "Sub-distric".localized(language), placeHolder: "Sub-distric".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kecamatanPerusahaan, label: "Distric".localized(language), placeHolder: "Distric".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kabKotaPerusahaan, label: "City".localized(language), placeHolder: "City".localized(language), disabled: false, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$teleponPerusahaan, label: "Phone".localized(language), placeHolder: "Phone".localized(language), disabled: false, onEditingChanged: { (Bool) in
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
        .padding(.horizontal, 25)
        .padding(.bottom, 10)
    }
    
    // MARK: FORM PEKERJAAN
//    var FormKeluargaTerdekat: some View {
//        VStack {
//            LabelTextField(value: self.$profileVM.hubunganKeluarga, label: "Hubungan Keluarga".localized(language), placeHolder: "Hubungan Keluarga".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.namaKeluarga, label: "Nama".localized(language), placeHolder: "Nama".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.alamatKeluarga, label: "Alamat".localized(language), placeHolder: "Alamat".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.kodePosKeluarga, label: "Kode Pos".localized(language), placeHolder: "Kode Pos".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.kelurahanKeluarga, label: "Kelurahan".localized(language), placeHolder: "Kelurahan".localized(language), disabled: false, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.kecamatanKeluarga, label: "Kecamatan".localized(language), placeHolder: "Kecamatan".localized(language), disabled: false, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//
//            LabelTextField(value: self.$profileVM.teleponKeluarga, label: "Telepon".localized(language), placeHolder: "Telepon".localized(language), disabled: false, onEditingChanged: { (Bool) in
//                print("on edit")
//            }, onCommit: {
//                print("on commit")
//            })
//        }
//    }
    
//    var FormPenyandangDana: some View {
//        VStack {
//
//            Text("Data Penyandang Dana".localized(language))
//                .font(.custom("Montserrat-Bold", size: 22))
//                .foregroundColor(Color(hex: "#232175"))
//                .fixedSize(horizontal: false, vertical: true)
//
//            VStack {
//                LabelTextField(value: self.$profileVM.namaPenyandang, label: "Nama".localized(language), placeHolder: "Nama".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                    print("on edit")
//                }, onCommit: {
//                    print("on commit")
//                })
//
//                LabelTextField(value: self.$profileVM.hubunganPenyandang, label: "Hubungan".localized(language), placeHolder: "Hubungan".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                    print("on edit")
//                }, onCommit: {
//                    print("on commit")
//                })
//
//                LabelTextField(value: self.$profileVM.pekerjaanPenyandang, label: "Pekerjaan".localized(language), placeHolder: "Pekerjaan".localized(language), disabled: true, onEditingChanged: { (Bool) in
//                    print("on edit")
//                }, onCommit: {
//                    print("on commit")
//                })
//            }
//            .padding(.top, 20)
//        }
//        .padding(30)
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
//        .padding(.horizontal, 25)
//        .padding(.bottom, 10)
//    }
}

struct FormChangeOtherDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeOtherDataView(namaPenyandangDana: .constant(""), tujuanPembukaan: .constant(""), sumberDana: .constant(""), frekuensiPenarikanPerbulan: .constant(""), jumlahPenarikanPerbulan: .constant(""), frekuensiSetoranPerbulan: .constant(""), jumlahSetoranPerbulan: .constant(""), pekerjaan: .constant(""), penghasilanKotor: .constant(""), otherIncome: .constant(""), namaPerusahaan: .constant(""), alamatPerusahaan: .constant(""), kodePosPerusahaan: .constant(""), kelurahanPerusahaan: .constant(""), kecamatanPerusahaan: .constant(""), kabKotaPerusahaan: .constant(""), provinsiPerusahaan: .constant(""), teleponPerusahaan: .constant(""))
    }
}
