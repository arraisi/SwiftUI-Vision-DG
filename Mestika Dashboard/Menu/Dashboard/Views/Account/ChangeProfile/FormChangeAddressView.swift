//
//  FormChangeAddressView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI
import Indicators
import Combine

struct FormChangeAddressView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var profileVM = ProfileViewModel()
    @StateObject var addressVM = AddressSummaryViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    @State var showModalError: Bool = false
    
    @State var kodePosSuratMenyurat: String = ""
    
    @State var allProvince = MasterProvinceResponse()
    @State var allRegency = MasterRegencyResponse()
    
    @State var routingForgotPassword: Bool = false
    
//    @State var provinsi: String = ""
    
    var body: some View {
        
        NavigationLink(
            destination: TransactionForgotPinView(),
            isActive: self.$routingForgotPassword,
            label: {}
        )
        
        ZStack {
            
            VStack(spacing: 0) {
                
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
                            VStack(spacing: 20) {
                                FormAddress
                                
                                
                                FormAddressMailing
                                
                                
                                if !self.profileVM.existingCustomer {
                                    Button(action: {
                                        
                                        self.profileVM.kodePosSuratMenyurat = self.kodePosSuratMenyurat
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
                                }
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 25)
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
        .navigationBarTitle("Address", displayMode: .inline)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{
            self.profileVM.getCustomerFromPhoenix { (isSuccess) in
                print("\nGet customer phoenix in account tab is success: \(isSuccess)\n")
                self.kodePosSuratMenyurat = self.profileVM.kodePosSuratMenyurat
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
    
    var FormAddress: some View {
        VStack {
            
            Text("Address Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
            
            VStack {
                LabelTextField(value: self.$profileVM.alamat, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
                        
                        TextField("Province".localized(language), text: $profileVM.provinsiName)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allProvince.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.provinsiName = self.allProvince[i].name
                                    self.getRegencyByIdProvince(idProvince: self.allProvince[i].id)
                                }) {
                                    Text(self.allProvince[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
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
                        
                        TextField("Province".localized(language), text: $profileVM.kabupatenName)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allRegency.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.kabupatenName = self.allRegency[i].name
                                }) {
                                    Text(self.allRegency[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                LabelTextField(value: self.$profileVM.kecamatanName, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kelurahanName, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
            
            Text("Mailing Address Data".localized(language))
                .font(.custom("Montserrat-Bold", size: 22))
                .foregroundColor(Color(hex: "#232175"))
            
            VStack {
                LabelTextField(value: self.$profileVM.alamatSuratMenyurat, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
                        
                        TextField("Province".localized(language), text: $profileVM.provinsiSuratMenyurat)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allProvince.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.provinsiSuratMenyurat = self.allProvince[i].name
                                    self.getRegencyByIdProvince(idProvince: self.allProvince[i].id)
                                }) {
                                    Text(self.allProvince[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                // City Mailing
                VStack(alignment: .leading) {
                    Text("City".localized(language))
                        .font(Font.system(size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("City".localized(language), text: $profileVM.kabupatenSuratMenyurat)
                            .font(Font.system(size: 14))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<self.allRegency.count, id: \.self) { i in
                                Button(action: {
                                    profileVM.kabupatenSuratMenyurat = self.allRegency[i].name
                                }) {
                                    Text(self.allRegency[i].name)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .frame(alignment: .leading)
                
                LabelTextField(value: self.$profileVM.kecamatanSuratMenyurat, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kelurahanSuratMenyurat, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$kodePosSuratMenyurat, label: "Postal Code".localized(language), placeHolder: "Postal Code".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                .keyboardType(.numberPad)
                .onReceive(self.kodePosSuratMenyurat.publisher.collect()) {
                    self.kodePosSuratMenyurat = String($0.prefix(5))
                }
                
            }
            .padding(.top, 20)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
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

struct FormChangeAddressView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeAddressView()
    }
}
