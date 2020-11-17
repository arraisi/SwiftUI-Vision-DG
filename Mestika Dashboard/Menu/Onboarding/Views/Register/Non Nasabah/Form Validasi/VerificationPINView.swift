//
//  VerificationPINView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI
import PopupView

struct VerificationPINView: View {
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    
    @State var pin: String = ""
    @State private var secured: Bool = true
    
    @State var isChecked:Bool = false
    
    func toggle() { isChecked = !isChecked }
    
    var disableForm: Bool {
        pin.count < 6
    } 
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
            
            VStack {
                Text("VERIFIKASI PIN KARTU ATM ANDA")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .center) {
                    Text("Silahkan Masukan PIN kartu ATM Anda")
                        .font(.title2)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if (secured) {
                        ZStack {
                            HStack (spacing: 0) {
                                SecureField("Maukan PIN ATM", text: $pin)
                                    .padding()
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .keyboardType(.phonePad)
                                
                                Button(action: {
                                    self.secured.toggle()
                                }) {
                                    Text("show")
                                        .frame(width: 80, height: 50)
                                        .cornerRadius(10)
                                        .foregroundColor(Color(hex: "#3756DF"))
                                }
                            }.padding()
                            RoundedRectangle(cornerRadius: 10).stroke()
                                .frame(width: 280, height: 50)
                                .foregroundColor(Color.secondary.opacity(0.2))
                        }
                    } else {
                        ZStack {
                            HStack (spacing: 0) {
                                TextField("Maukan PIN ATM", text: $pin)
                                    .padding()
                                    .frame(width: 200, height: 50)
                                    .foregroundColor(Color(hex: "#232175"))
                                    .keyboardType(.phonePad)
                                
                                Button(action: {
                                    self.secured.toggle()
                                }) {
                                    Text("show")
                                        .frame(width: 80, height: 50)
                                        .cornerRadius(10)
                                        .foregroundColor(Color(hex: "#3756DF"))
                                }
                            }.padding()
                            RoundedRectangle(cornerRadius: 10).stroke()
                                .frame(width: 280, height: 50)
                                .foregroundColor(Color.secondary.opacity(0.2))
                        }
                    }
                    
                    Button(action: toggle) {
                        HStack(alignment: .top) {
                            Image(systemName: isChecked ? "checkmark.square": "square")
                            Text("* Rekening Anda tidak memiliki kartu ATM? \n Verifikasi Lewat Video Call")
                                .font(.caption)
                                .foregroundColor(Color(hex: "#707070"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 5)
                    }
                    
                    Button(action: {
                        showingModal.toggle()
                    }) {
                        Text("Berikutnya")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    }
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(disableForm)
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
    }
    
    /*
     Fuction for Create Bottom Floater (Modal)
     */
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("Logo M")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Text("PIN ATM yang anda Masukkan Salah!")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#DF1C1C"))
                .padding(.bottom, 30)
            
            Text("PIN ATM yang Anda masukkan tidak sesuai dengan PIN ATM rekening terdaftar.")
                .font(.caption)
                .foregroundColor(Color(hex: "#232175"))
            
            Text("Silahkan coba kembali..")
                .font(.caption)
                .bold()
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: InterviewRegistrationView()) {
                Text("Pendaftaran Melalui Wawancara")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct VerificationPINView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationPINView().environmentObject(RegistrasiModel())
    }
}
