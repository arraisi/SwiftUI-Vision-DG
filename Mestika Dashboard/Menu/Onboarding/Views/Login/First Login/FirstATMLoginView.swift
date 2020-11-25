//
//  FirstATMLoginView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 12/10/20.
//

import SwiftUI

struct FirstATMLoginView: View {
    
    /* Routing Bool */
    @State private var nextRoute: Bool = false
    @EnvironmentObject var appState: AppState
    
    @State var atmNumber: String = ""
    @State var pin: String = ""
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    
    /* Disabled Form */
    var disableForm: Bool {
        pin.count < 6 || atmNumber.count < 6
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Image("bg_blue")
                .resizable()
            
            VStack {
                
                VStack {
                    Text("MASUKKAN DATA ANDA")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 100)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            popupMessage()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text("Masukkan nomor kartu ATM dan PIN ATM Anda yang sudah terdaftar")
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            TextField("Masukan nomor ATM Anda", text: $atmNumber, onEditingChanged: { changed in
                print("\($atmNumber)")
            })
            .frame(height: 20)
            .font(.subheadline)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            TextField("Masukan PIN ATM Anda", text: $pin, onEditingChanged: { changed in
                print("\($pin)")
            })
            .frame(height: 20)
            .font(.subheadline)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            Button(
                action: {
                    checkPinAndAtm()
                },
                label: {
                    Text("Masukkan Data Kartu ATM Anda")
                        .foregroundColor(disableForm ? .white : Color(hex: "#232175"))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .background(disableForm ? Color.gray.opacity(0.3) : Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(disableForm)
            
            NavigationLink(
                destination: FirstPasswordLoginView(),
                isActive: self.$nextRoute,
                label: {}
            )
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func checkPinAndAtm() {
        if (deviceId == user.last?.deviceId && pin == user.last?.pin) {
            
            print("DATA READY")
            nextRoute = true
            
        } else {
            
            print("NO DATA")
            showingModal.toggle()
            
        }
    }
    
    // MARK:- POPUP MESSAGE
    func popupMessage() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("PIN atau Nomor ATM anda salah")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Text("Data yang anda masukan tidak sesuai, silahkan masukkan kembali.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            Button(action: {
//                self.rootIsActive = true
                self.appState.moveToWelcomeView = true
            }) {
                Text("Kembali")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
}

#if DEBUG
struct FirstATMLoginView_Previews: PreviewProvider {
    static var previews: some View {
        FirstATMLoginView()
    }
}
#endif
