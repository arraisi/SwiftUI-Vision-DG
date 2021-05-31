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
    
    //    @State var nextRoute: Bool = false
    
    @StateObject var profileVM = ProfileViewModel()
    
    @EnvironmentObject var appState: AppState
    
    @State var pinActive: Bool = false
    @State var wrongPin: Bool = false
    @State var showModal: Bool = false
    
    var body: some View {
        
        if pinActive {
            
            PinConfirmationChangeDataView(wrongPin: $wrongPin) { pin in
                print("\nupdate customer personal data")
                profileVM.updateCustomerPhoenix(pinTrx: pin) { result in
                    print("update customer personal data is success : \(result)\n")
                    if result {
                        self.showModal = true
                    } else { self.wrongPin = true }
                }
            }
            
        } else {
            ZStack {
                VStack {
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            
                            Text("Personal Data".localized(language))
                                .font(.custom("Montserrat-Bold", size: 22))
                                .foregroundColor(Color(hex: "#232175"))
                                .padding()
                            
                            VStack {
                                LabelTextField(value: self.$profileVM.name, label: "Name".localized(language), placeHolder: "Name".localized(language), disabled: !self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                    print("on edit")
                                }, onCommit: {
                                    print("on commit")
                                })
                                
                                LabelTextField(value: self.$profileVM.telepon, label: "Telephone".localized(language), placeHolder: "Telephone".localized(language), disabled: self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                    print("on edit")
                                }, onCommit: {
                                    print("on commit")
                                })
                                .keyboardType(.numberPad)
                                
                                LabelTextField(value: self.$profileVM.email, label: "e-Mail".localized(language), placeHolder: "e-Mail".localized(language), disabled: !self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                    print("on edit")
                                }, onCommit: {
                                    print("on commit")
                                })
                                
                                LabelTextField(value: self.$profileVM.tempatLahir, label: "Place of Birth".localized(language), placeHolder: "Place of Birth".localized(language), disabled: !self.profileVM.existingCustomer, onEditingChanged: { (Bool) in
                                    print("on edit")
                                }, onCommit: {
                                    print("on commit")
                                })
                                
                                //                LabelTextField(value: self.$dateOfBirth, label: "Date of Birth".localized(language), placeHolder: "Date of Birth".localized(language), disabled: false, onEditingChanged: { (Bool) in
                                //                    print("on edit")
                                //                }, onCommit: {
                                //                    print("on commit")
                                //                })
                                
                                LabelTextFieldMenu(value: self.$profileVM.gender, label: "Gender", data: ["Laki-laki", "Perempuan"], disabled: !profileVM.existingCustomer, onEditingChanged: {_ in}, onCommit: {})
                                
                                VStack(spacing: 10) {
                                    if !self.profileVM.existingCustomer {
                                        Button(action: {
                                            
                                            //                                            self.pinActive = true
                                            self.showModal = true
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
            .navigationBarTitle("Account", displayMode: .inline)
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
