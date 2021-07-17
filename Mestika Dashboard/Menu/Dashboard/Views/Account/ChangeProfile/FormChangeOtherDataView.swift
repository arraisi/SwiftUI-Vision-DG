//
//  FormChangeOtherDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/05/21.
//

import SwiftUI
import Indicators
import Combine

struct FormChangeOtherDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    @State var showModalError: Bool = false
    @State private var isLoading: Bool = false
    
    @State var telepon: String = ""
    @State var kodePosPerusahaan: String = ""
    
    @StateObject var addressVM = AddressSummaryViewModel()
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    
    @State var routingForgotPassword: Bool = false
    
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
        ZStack {
            VStack(spacing: 0) {
                
                NavigationLink(
                    destination: TransactionForgotPinView(),
                    isActive: self.$routingForgotPassword,
                    label: {}
                )
                
                CustomAppBar(light: false)
                
                if (self.profileVM.isLoading) {
                    LinearWaitingIndicator()
                        .animated(true)
                        .foregroundColor(.green)
                        .frame(height: 1)
                }
                
                if pinActive {
                    
                    PinConfirmationChangeDataView(wrongPin: $wrongPin) { pin in
                        profileVM.updateCustomerPhoenix(pinTrx: pin) { result in
                            if result {
                                self.pinActive = false
                                self.showModal = true
                            } else {
                                
                                if (profileVM.statusCode == "406") {
                                    self.showModalError = true
                                } else {
                                    self.wrongPin = true
                                }
                                
                            }
                        }
                    }
                    
                } else {
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 25) {
                                FormPembuatanRekening
                                
                                
                                if (self.profileVM.namaPerusahaan == "" && self.profileVM.provinsiPerusahaan == "") {
                                    EmptyView()
                                } else {
                                    FormPekerjaan
                                    
                                    FormPerusahaan
                                }
                                
                                if !profileVM.existingCustomer {
                                    Button(action: {
                                        self.profileVM.teleponPerusahaan = self.telepon
                                        self.profileVM.kodePosPerusahaan = self.kodePosPerusahaan
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
                }
            }
            
            if self.showModal || self.showModalError {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            SuccessChangePasswordModal()
        }
        .popup(isPresented: $showModalError, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popupMessageError()
        }
        .navigationBarTitle("Other Data", displayMode: .inline)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{
            self.profileVM.getCustomerFromPhoenix { (isSuccess) in
                print("\nGet customer phoenix in account tab is success: \(isSuccess)\n")
                self.kodePosPerusahaan = self.profileVM.kodePosPerusahaan
                self.telepon = self.profileVM.teleponPerusahaan
            }
            
            self.addressVM.getAllProvince { success in
                
                if success {
                    self.allProvince = self.addressVM.provinceResult
                }
                
                if !success {
                    
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
                
                LabelTextFieldMenu(value: self.$profileVM.jumlahPenarikanDanaPerbulan, label: "Monthly witdrawal amount".localized(language), data: besarPerkiraanPenarikanData.map{$0.name}, disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
    
    // MARK: POPUP MESSAGE ERROR
    func popupMessageError() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("PIN Transaksi Terblokir".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {
                self.showModalError = false
                routingForgotPassword = true
            }) {
                Text("Forgot Pin Transaction".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
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
                
                // Province
                VStack(alignment: .leading) {
                    Text("Province".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Province".localized(language), text: $profileVM.provinsiPerusahaan)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allProvince.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.provinsiPerusahaan = self.allProvince[i].name
                                    self.getRegencyByIdProvince(idProvince: self.allProvince[i].id)
                                }) {
                                    Text(self.allProvince[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        .disabled(profileVM.existingCustomer)
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                // City
                VStack(alignment: .leading) {
                    Text("City".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("City".localized(language), text: $profileVM.kotaPerusahaan)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allRegency.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.kotaPerusahaan = self.allRegency[i].name
                                }) {
                                    Text(self.allRegency[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        .disabled(profileVM.existingCustomer)
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                LabelTextField(value: self.$profileVM.kecamatanPerusahaan, label: "Distric".localized(language), placeHolder: "Distric".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kelurahanPerusahaan, label: "Sub-distric".localized(language), placeHolder: "Sub-distric".localized(language), disabled: profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                VStack(alignment: .leading) {
                    Text("Postal Code".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    TextField("Postal Code".localized(language), text: self.$kodePosPerusahaan)
                        .frame(height: 36)
                        .font(Font.system(size: 14))
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .disabled(self.profileVM.existingCustomer)
                        .keyboardType(.numberPad)
                        .onReceive(Just(kodePosPerusahaan)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.kodePosPerusahaan = filtered
                            }
                        }
                        .onReceive(kodePosPerusahaan.publisher.collect()) {
                            self.kodePosPerusahaan = String($0.prefix(5))
                        }
                }
                
                VStack(alignment: .leading) {
                    Text("Telephone".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    TextField("Telephone".localized(language), text: self.$telepon)
                        .frame(height: 36)
                        .font(Font.system(size: 14))
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .disabled(self.profileVM.existingCustomer)
                        .keyboardType(.numberPad)
                        .onReceive(Just(telepon)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.telepon = filtered
                            }
                        }
                        .onReceive(telepon.publisher.collect()) {
                            self.telepon = String($0.prefix(14))
                        }
                }
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
    
    
    func getRegencyByIdProvince(idProvince: String) {
        self.addressVM.getRegencyByIdProvince(idProvince: idProvince) { success in
            
            if success {
                self.allRegency = self.addressVM.regencyResult
            }
            
            if !success {
                
            }
        }
    }
}

struct FormChangeOtherDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FormChangeOtherDataView()
        }
    }
}
