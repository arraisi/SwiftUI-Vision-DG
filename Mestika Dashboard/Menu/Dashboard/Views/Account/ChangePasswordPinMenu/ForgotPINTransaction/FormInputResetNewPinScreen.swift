//
//  FormInputResetNewPinScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct FormInputResetNewPinScreen: View {
    
    var cardNo = ""
    
    @State private var pinCtrl = ""
    @State private var pinConfirmCtrl = ""
    
    @State private var showPin: Bool = false
    @State private var showPinConfirm: Bool = false
    @State private var showModal: Bool = false
    @State private var isPinChanged: Bool = false
    
    private var simpanBtnDisabled: Bool {
        pinCtrl.count == 0 || pinConfirmCtrl.count == 0 || pinCtrl != pinConfirmCtrl
    }
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            
            VStack {
                
                AppBarLogo(light: true) {}
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        Text("LUPA PIN")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        Text("Silahkan masukkan PIN baru Anda")
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(Color(hex: "#002251"))
                            .padding(.top, 10)
                        
                        VStack(alignment: .leading) {
                            
                            Text("PIN Baru")
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 10)
                            
                            VStack {
                                HStack {
                                    if (showPin) {
                                        TextField("Input PIN baru Anda", text: self.$pinCtrl)
                                    } else {
                                        SecureField("Input PIN baru Anda", text: self.$pinCtrl)
                                    }
                                    
                                    Button(action: {
                                        self.showPin.toggle()
                                    }, label: {
                                        Image(systemName: showPin ? "eye.fill" : "eye.slash")
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                                
                                Divider()
                                
                                HStack {
                                    if (showPinConfirm) {
                                        TextField("Input Ulang PIN baru Anda", text: self.$pinConfirmCtrl)
                                    } else {
                                        SecureField("Input Ulang PIN baru Anda", text: self.$pinConfirmCtrl)
                                    }
                                    
                                    Button(action: {
                                        self.showPinConfirm.toggle()
                                    }, label: {
                                        Image(systemName: showPinConfirm ? "eye.fill" : "eye.slash")
                                            .foregroundColor(Color(hex: "#3756DF"))
                                    })
                                }
                                .frame(height: 25)
                                .padding(.vertical, 10)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        }
                        .padding()
                        
                        Spacer()
                        
                        NavigationLink(destination: FormInputResetPinScreen(cardNo: self.cardNo, newPin: self.pinCtrl), label: {
                            Text("Simpan PIN Baru")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        })
                        .isDetailLink(false)
                        .disabled(simpanBtnDisabled)
                        .background(simpanBtnDisabled ? Color(.lightGray) : Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                    .padding()
                }
            }
            
            if self.showModal {
                ModalOverlay(tapAction: { withAnimation { self.showModal = false } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }))
        .popup(isPresented: $showModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            ZStack {
                if isPinChanged {
                    SuccessChangePinModal()
                } else {
                    FailedChangePinModal()
                }
            }
        }
    }
    // MARK: POPUP SUCCSESS CHANGE PIN
    func SuccessChangePinModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_check")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("PIN APLIKASI YANG BARU TELAH BERHASIL DISIMPAN")
                .font(.custom("Montserrat-ExtraBold", size: 20))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                self.showModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: POPUP FAILED CHANGE PIN
    func FailedChangePinModal() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("ic_attention")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("PIN not Changed")
                .font(.custom("Montserrat-Bold", size: 24))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.vertical)
            
            Button(action: {
                self.showModal = false
            }) {
                Text("OK")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct FormInputResetNewPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        FormInputResetNewPinScreen()
    }
}
