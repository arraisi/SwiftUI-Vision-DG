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
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    
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
                        VStack(spacing: 20) {
                            FormAddress
                            
                            
                            FormAddressMailing
                            
                            
                            if !self.profileVM.existingCustomer {
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
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 25)
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
            .navigationBarTitle("Address", displayMode: .inline)
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
                
                LabelTextField(value: self.$profileVM.kelurahanName, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kecamatanName, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kabupatenName, label: "City".localized(language), placeHolder: "City".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.provinsiName, label: "Province".localized(language), placeHolder: "Province".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
                LabelTextField(value: self.$profileVM.alamatSuratMenyurat, label: "Address".localized(language), placeHolder: "Address".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kodePosSuratMenyurat, label: "Postal Code".localized(language), placeHolder: "Postal Code".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kelurahanSuratMenyurat, label: "Village".localized(language), placeHolder: "Village".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kecamatanSuratMenyurat, label: "Sub-District".localized(language), placeHolder: "Sub-District".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.kotaSuratMenyurat, label: "City".localized(language), placeHolder: "City".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.provinsiSuratMenyurat, label: "Province".localized(language), placeHolder: "Province".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
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
}

struct FormChangeAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormChangeAddressView()
        }
    }
}
