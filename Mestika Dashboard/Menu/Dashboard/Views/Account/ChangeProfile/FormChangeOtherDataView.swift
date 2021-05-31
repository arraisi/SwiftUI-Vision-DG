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
    
    @StateObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    @State private var isLoading: Bool = false
    
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
        if pinActive {
            
            PinConfirmationChangeDataView(wrongPin: $wrongPin) { pin in
                profileVM.updateCustomerPhoenix(pinTrx: pin) { result in
                    if result {
                        self.pinActive = false
                        self.showModal = true
                    } else {
                        self.wrongPin = true
                        
                    }
                }
            }
            
        } else {
            ZStack {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 25) {
                            FormPembuatanRekening
                            
                            
                            if (self.profileVM.namaPerusahaan == "") {
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
                            
                            if !profileVM.existingCustomer {
                                Button(action: {
                                    self.pinActive = true
                                }) {
                                    Text("Save".localized(language))
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                }
                                .background(Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal, 25)
                                .padding(.bottom, 30)
                            }
                            
                        }
                        .padding(.top, 20)
                    }
                }
                if self.showModal {
                    ModalOverlay(tapAction: { withAnimation { } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
                SuccessChangePasswordModal()
            }
            .navigationBarTitle("Other Data", displayMode: .inline)
            .onTapGesture() {
                UIApplication.shared.endEditing()
            }
            .onAppear{
                self.profileVM.getCustomerFromPhoenix { (isSuccess) in
                    print("\nGet customer phoenix in account tab is success: \(isSuccess)\n")
                    
                }
            }
            
        }
    }
    
    // MARK: FORM PEMBUKAAN REKENING
    var FormPembuatanRekening: some View {
        VStack {
            
            Text("Account Opening Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            VStack {
                LabelTextFieldMenu(value: self.$profileVM.tujuanPembukaan, label: "Opening Purpose".localized(language), data: tujuanPembukaanRekeningData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.sumberDana, label: "Source of funds".localized(language), data: sumberDanaData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.jumlahPenarikanPerbulan, label: "Monthly witdrawal".localized(language), data: perkiraanPenarikanData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.jumlahSetoranDanaPerbulan, label: "Monthly witdrawal amount".localized(language), data: besarPerkiraanPenarikanData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.jumlahSetoranPerbulan, label: "Monthly deposit".localized(language), data: perkiraanSetoranData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.jumlahSetoranDanaPerbulan, label: "Monthly deposit amount".localized(language), data: besarPerkiraanSetoranData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 25)
    }
    
    // MARK: POPUP SUCCSESS 
    func SuccessChangePasswordModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("The Latest Data Has Been Successfully Saved".localized(language))
                .font(.custom("Montserrat-ExtraBold", size: 18))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                
                self.appState.moveToAccountTab = true
                self.showModal = false
                //                self.routeDashboard = true
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.bottom, 15)
        .padding(15)
    }
    
    // MARK: FORM PEKERJAAN
    var FormPekerjaan: some View {
        VStack {
            
            Text("Occupation Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            
            VStack {
                LabelTextFieldMenu(value: self.$profileVM.pekerjaan, label: "Occupation".localized(language), data: pekerjaanData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.penghasilanKotor, label: "Gross income".localized(language), data: penghasilanKotorData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextFieldMenu(value: self.$profileVM.PendapatanLainnya, label: "Other income".localized(language), data: otherIncomeData, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 25)
    }
    
    // MARK: FORM PERUSHAAN
    var FormPerusahaan: some View {
        
        VStack {
            
            Text("Company Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            
            VStack {
                LabelTextField(value: self.$profileVM.namaPerusahaan, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.alamatPerusahaan, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kodePosPerusahaan, label: "Postal Code".localized(language), placeHolder: "Postal Code".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kelurahanPerusahaan, label: "Sub-distric".localized(language), placeHolder: "Sub-distric".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kecamatanPerusahaan, label: "Distric".localized(language), placeHolder: "Distric".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kotaPerusahaan, label: "City".localized(language), placeHolder: "City".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.teleponPerusahaan, label: "Phone".localized(language), placeHolder: "Phone".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                .keyboardType(.numberPad)
                
            }
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
        .padding(.horizontal, 25)
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
        NavigationView {
            FormChangeOtherDataView()
        }
    }
}
