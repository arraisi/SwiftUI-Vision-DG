//
//  FormChangePinView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI

struct FormChangePinTransactionView: View {
    
    @State private var oldPinCtrl = ""
    
    @State private var pinCtrl = ""
    @State private var pinConfirmCtrl = ""
    
    @State private var showPin: Bool = false
    @State private var showOldPin: Bool = false
    @State private var showPinConfirm: Bool = false
    @State private var showModal: Bool = false
    @State private var isPinChanged: Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                AppBarLogo(light: true) {}
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        Text("Ubah PIN")
                            .font(.custom("Montserrat-Bold", size: 24))
                            .foregroundColor(Color(hex: "#232175"))
                        
                        VStack(alignment: .leading) {
                            
                            Text("Silahkan masukkan PIN lama dan baru Anda")
                                .font(.custom("Montserrat-Regular", size: 14))
                                .foregroundColor(Color(hex: "#002251"))
                                .padding(.top, 5)
                            
                            Text("PIN Lama")
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .padding(.top, 5)
                            
                            HStack {
                                if (showOldPin) {
                                    TextField("Input PIN lama Anda", text: self.$oldPinCtrl)
                                } else {
                                    SecureField("Input PIN lama Anda", text: self.$oldPinCtrl)
                                }
                                
                                Button(action: {
                                    self.showOldPin.toggle()
                                }, label: {
                                    Image(systemName: showOldPin ? "eye.fill" : "eye.slash")
                                        .foregroundColor(Color(hex: "#3756DF"))
                                })
                            }
                            .frame(height: 25)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 10)
                            
                        }
                        .padding()
                        
                        VStack(alignment: .leading) {
                            
                            Text("PIN Baru")
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(Color(hex: "#2334D0"))
                            
                            VStack {
                                HStack {
                                    if (showPin) {
                                        TextField("Input PIN baru Anda", text: self.$pinCtrl)
                                    } else {
                                        SecureField("Input Ulang PIN baru Anda", text: self.$pinCtrl)
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
                                        TextField("Confirm PIN", text: self.$pinConfirmCtrl)
                                    } else {
                                        SecureField("Confirm PIN", text: self.$pinConfirmCtrl)
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
                        
                        Button(action: {
                            self.showModal.toggle()
                        }, label: {
                            Text("Simpan PIN Baru")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                            
                        })
                        .background(Color(hex: "#2334D0"))
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

struct FormChangePinView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangePinTransactionView()
    }
}
