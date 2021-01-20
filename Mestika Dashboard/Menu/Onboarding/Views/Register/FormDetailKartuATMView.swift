//
//  DetailKartuATMView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 21/10/20.
//

import SwiftUI
import NavigationStack
import SDWebImageSwiftUI

struct FormDetailKartuATMView: View {
    
    @EnvironmentObject var atmData: AddProductATM
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @ObservedObject private var productVM = ATMProductViewModel()
    
    var isAllowBack: Bool = true
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    
    @State private var is_video_call = UserDefaults.standard.string(forKey: "register_nasabah_video_call")
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 100)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                    .frame(height: 100)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25){
                        HStack {
                            Text(NSLocalizedString("KARTU ATM ANDA \nAKAN SEGERA DIKIRIM", comment: ""))
                                .font(.custom("Montserrat-Bold", size: 24))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.top, 10)
                        //                    Image("atm_bromo")
                        //                        .resizable()
                        //                        .aspectRatio(contentMode: .fit)
                        
                        //                        WebImage(url: registerData.desainKartuATMImage)
                        //                            .onSuccess { image, data, cacheType in
                        //                                // Success
                        //                                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        //                            }
                        //                            .placeholder {
                        //                                Rectangle().foregroundColor(.gray).opacity(0.5)
                        //                            }
                        //                            .resizable()
                        //                            .indicator(.activity) // Activity Indicator
                        //                            .transition(.fade(duration: 0.5)) // Fade Transition with duration
                        //                            .scaledToFill()
                        //                            .cornerRadius(10)
                        
                        Image(uiImage: registerData.desainKartuATMImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(Color.clear)
                        
                        HStack {
                            Text(NSLocalizedString("Selamat data kartu ATM baru Anda telah berhasil disimpan.", comment: ""))
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#1D2238"))
                            Spacer()
                        }
                        
                        VStack {
                            HStack{
                                Text(NSLocalizedString("Nama", comment: ""))
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#707070"))
                                
                                Spacer()
                                
                                TextField(NSLocalizedString("Nama", comment: ""), text: $atmData.atmName) { (isChanged) in
                                    
                                } onCommit: {
                                    
                                }
                                .disabled(true)
                                .font(.custom("Montserrat-Regular", size: 12))
                                .frame(width: 200, height: 36)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            
                            //                            if (is_video_call == "true" || registerData.isNasabahmestika == false) {
                            //                                EmptyView()
                            //                            } else {
                            //                                Group {
                            //                                    HStack {
                            //                                        Text(NSLocalizedString("No. Kartu", comment: ""))
                            //                                            .font(.custom("Montserrat-Regular", size: 12))
                            //                                            .foregroundColor(Color(hex: "#707070"))
                            //
                            //                                        Spacer()
                            //
                            //                                        TextField(NSLocalizedString("No. Kartu", comment: ""), text: Binding.constant("")) { (isChanged) in
                            //
                            //                                        } onCommit: {
                            //
                            //                                        }
                            //                                        .font(.custom("Montserrat-Regular", size: 12))
                            //                                        .frame(width: 200, height: 36)
                            //                                        .padding(.horizontal)
                            //                                        .background(Color.gray.opacity(0.1))
                            //                                        .cornerRadius(10)
                            //                                        .disabled(true)
                            //                                    }
                            //
                            //                                    HStack {
                            //                                        Text("Expired")
                            //                                            .font(.custom("Montserrat-Regular", size: 12))
                            //                                            .foregroundColor(Color(hex: "#707070"))
                            //
                            //                                        Spacer()
                            //
                            //                                        TextField("Expired", text: Binding.constant("")) { (isChanged) in
                            //
                            //                                        } onCommit: {
                            //
                            //                                        }
                            //                                        .font(.custom("Montserrat-Regular", size: 12))
                            //                                        .frame(width: 200, height: 36)
                            //                                        .padding(.horizontal)
                            //                                        .background(Color.gray.opacity(0.1))
                            //                                        .cornerRadius(10)
                            //                                        .disabled(true)
                            //                                    }
                            //                                }
                            //                            }
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Silahkan tunggu beberapa saat sampai kartu ATM Anda diterima.", comment: ""))
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#1D2238"))
                            Spacer()
                        }
                        
                        Spacer()
                        Button(action: {
                            self.appState.moveToWelcomeView = true
                        }) {
                            Text(NSLocalizedString("KEMBALI KE HALAMAN UTAMA", comment: ""))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(height: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 25)
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Apakah ingin membatalkan registrasi ?", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YA", comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("Tidak", comment: ""))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
    }
}

struct DetailKartuATMView_Previews: PreviewProvider {
    static var previews: some View {
        FormDetailKartuATMView().environmentObject(AddProductATM()).environmentObject(RegistrasiModel())
    }
}
