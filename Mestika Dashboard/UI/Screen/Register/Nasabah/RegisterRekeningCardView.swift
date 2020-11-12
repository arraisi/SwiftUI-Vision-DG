//
//  RegisterRekeningCardView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView

struct JenisNoKartu {
    var jenis: String
}

struct RegisterRekeningCardView: View {
    
    let jenisKartuList:[JenisNoKartu] = [
        .init(jenis: "Kartu ATM"),
        .init(jenis: "Rekening"),
    ]
    
    /* Environtment Object */
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var jenisKartuCtrl: String = ""
    @State var noKartuCtrl: String = ""
    
    /* Data Binding */
    @Binding var rootIsActive : Bool
    
    /* Modal Boolean */
    @State var showingModal = false
    
    /* Disabled Form */
    var disableForm: Bool {
        noKartuCtrl.count < 6
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                VStack(alignment: .center) {
                    Text("No. Kartu ATM atau Rekening")
                        .font(.title3)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    Text("Silahkan masukan no kartu ATM atau Rekening anda")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(Color(hex: "#5A6876"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 50)
                    
                    HStack {
                        TextField("Pilih jenis no kartu yang diinput", text: $jenisKartuCtrl)
                            .font(.subheadline)
                            .frame(height: 36)
                            .padding(.leading, 20)
                            .disabled(true)
                        
                        Button(action:{
                            showingModal.toggle()
                            print("click")
                        }, label: {
                            Image(systemName: "chevron.down")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                        .padding(.trailing, 20)
                        
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    
                    TextField("Masukan no kartu", text: $noKartuCtrl)
                        .frame(height: 10)
                        .font(.subheadline)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    
                    Text("*Pastikan kartu ATM atau Rekening Anda telah aktif, jika belum aktifasi kartu ATM silahkan kunjungi Kantor Bank Mestika terdekat.")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundColor(Color(hex: "#5A6876"))
                        .padding(.top, 5)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                    
                    NavigationLink(
                        destination: RegisterNasabahPhoneOTPScreen(rootIsActive: self.$rootIsActive).environmentObject(registerData),
                        label: {
                            Text("Verifikasi No. Kartu")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                        })
                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .disabled(disableForm)
                    
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 100)
            .padding(.bottom, 35)
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.easeIn, closeOnTapOutside: true) {
            popupJenisKartu()
        }
    }
    
    func popupJenisKartu() -> some View {
        VStack {
            HStack {
                Text("Pilih jenis no kartu yang diinput")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Jenis Kartu", text: $jenisKartuCtrl)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    print("cari jenis")
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            List(0...jenisKartuList.count-1, id: \.self) {index in
                
                HStack {
                    Text(jenisKartuList[index].jenis)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(jenisKartuList[index])
                    jenisKartuCtrl = jenisKartuList[index].jenis
                    self.showingModal.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.vertical)
            .frame(height: 150)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct RegisterRekeningCardView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterRekeningCardView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}
