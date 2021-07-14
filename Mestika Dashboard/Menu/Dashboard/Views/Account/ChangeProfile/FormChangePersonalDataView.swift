//
//  FormChangePersonalDataView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 05/05/21.
//

import SwiftUI
import Indicators
import Combine

struct FormChangePersonalDataView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode
    
    //    @State var nextRoute: Bool = false
    
    @StateObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    @State var showModalError: Bool = false
    
    @State var routingForgotPassword: Bool = false
    
    @State var telepon: String = ""
    
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
                        print("\nupdate customer personal data")
                        profileVM.updateCustomerPhoenix(pinTrx: pin) { result in
                            print("update customer personal data is success : \(result)\n")
                            if result {
                                self.pinActive = false
                                self.showModal = true
                            } else {
                                if (profileVM.statusCode == "406") {
                                    self.showModalError = true
                                } else if (profileVM.statusCode == "400") {
                                    self.showModalError = true
                                }else {
                                    self.wrongPin = true
                                }
                            }
                        }
                    }
                    
                } else {
                    
                    VStack {
                        
                        ScrollView(showsIndicators: false) {
                            
                            VStack(spacing: 20) {
                                
                                Text("Personal Data".localized(language))
                                    .font(.custom("Montserrat-Bold", size: 22))
                                    .foregroundColor(Color(hex: "#232175"))
                                    .padding(.top)
                                
                                VStack {
                                    LabelTextField(value: self.$profileVM.name, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                    
                                    LabelTextField(value: self.$telepon, label: "Telephone".localized(language), placeHolder: "Telephone".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                    
                                    LabelTextField(value: self.$profileVM.email, label: "e-Mail".localized(language), placeHolder: "e-Mail".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                    
                                    LabelTextField(value: self.$profileVM.tempatLahir, label: "Place of Birth".localized(language), placeHolder: "Place of Birth".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                        print("on edit")
                                    }, onCommit: {
                                        print("on commit")
                                    })
                                    
                                    LabelTextFieldMenu(value: self.$profileVM.gender, label: "Gender", data: ["Laki-laki", "Perempuan"], disabled: profileVM.existingCustomer, onEditingChanged: {_ in}, onCommit: {})
                                    
                                }
                                
                                if !self.profileVM.existingCustomer {
                                    Button(action: {
                                        
                                        self.profileVM.telepon = self.telepon
                                        self.pinActive = true
                                        //                                        self.showModal = true
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
                            .padding(25)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                            .padding(.horizontal, 25)
                            .padding(.top, 30)
                        }
                        
                    }
                    
                }
                
                //                Spacer()
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
        .navigationBarTitle("Account", displayMode: .inline)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{
            self.profileVM.getCustomerFromPhoenix { (isSuccess) in
                print("\nGet customer phoenix in account tab is success: \(isSuccess)\n")
                self.telepon = self.profileVM.telepon
            }
        }
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
    
    
    // MARK: POPUP SUCCSESS CHANGE PASSWORD
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

struct FormChangePersonalDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            FormChangePersonalDataView()
        }
    }
}
