//
//  RegisterRekeningCardView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView
import SystemConfiguration

struct JenisNoKartu {
    var jenis: String
}

struct NoAtmOrRekeningVerificationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    let jenisKartuList:[JenisNoKartu] = [
        .init(jenis: "Kartu ATM"),
        .init(jenis: "Rekening"),
    ]
    
    /* Environtment Object */
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var jenisKartuCtrl: String = ""
    @State var noKartuCtrl: String = ""
    
    /* Root Binding */
    @State var isActive : Bool = false
    @Binding var rootIsActive : Bool
    
    /* Backstage */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    @State var isShowAlertInternetConnection = false
    private let reachability = SCNetworkReachabilityCreateWithName(nil, AppConstants().BASE_URL)
    
    /* Disabled Form */
    var disableForm: Bool {
        jenisKartuCtrl == "Kartu ATM" ? noKartuCtrl.count < 16 : noKartuCtrl.count < 11
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.5)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, onCancel: {})
                
                VStack(alignment: .center) {
                    Text("ATM Card or Account No.".localized(language))
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(.bold)
                        .padding(.top, 30)
                        .multilineTextAlignment(.center)
                    
                    Text("Please enter your ATM card or account number".localized(language))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                    
                    HStack {
                        TextField("Select the type of card no. Inputted".localized(language), text: $jenisKartuCtrl)
                            .onChange(of: jenisKartuCtrl, perform: { value in
                                noKartuCtrl = ""
                            })
                            .font(.custom("Montserrat-Regular", size: 12))
                            .frame(height: 50)
                            .padding(.leading, 15)
                            .disabled(true)
                        
                        Menu {
                            ForEach(0..<jenisKartuList.count, id: \.self) { i in
                                Button(action: {
                                    print(jenisKartuList[i])
                                    jenisKartuCtrl = jenisKartuList[i].jenis
                                }) {
                                    Text(jenisKartuList[i].jenis)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.right").padding()
                        }
                        
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .padding(.vertical, 5)
                    
                    TextField("Enter card no.".localized(language), text: $noKartuCtrl, onEditingChanged: { changed in
                        //                        self.registerData.accNo = self.noKartuCtrl
                        if (jenisKartuCtrl == "Kartu ATM") {
                            self.registerData.atmOrRekening = "ATM"
                            self.registerData.noAtm = self.noKartuCtrl
                            
                            self.registerData.accType = "ATM"
                            self.registerData.accNo = self.noKartuCtrl
                        } else {
                            self.registerData.atmOrRekening = "REKENING"
                            self.registerData.noRekening = self.noKartuCtrl
                            
                            self.registerData.accType = "REKENING"
                            self.registerData.accNo = self.noKartuCtrl
                        }
                        
                    })
                    .font(.custom("Montserrat-Regular", size: 12))
                    .keyboardType(.numberPad)
                    .padding(15)
                    .background(Color.gray.opacity(0.1))
                    .frame(height: 50)
                    .cornerRadius(20)
                    .onReceive(noKartuCtrl.publisher.collect()) {
                        if (jenisKartuCtrl == "Kartu ATM") {
                            self.noKartuCtrl = String($0.prefix(16))
                        } else {
                            self.noKartuCtrl = String($0.prefix(11))
                        }
                    }
                    
                    Text("* Make sure your ATM card or account is active, if you haven't activated your ATM card, please visit the nearest Mestika Bank Office.".localized(language))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .padding(.top, 5)
                        .padding(.bottom, 30)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Group {
                        Button(action: {
                            if (jenisKartuCtrl == "Kartu ATM") {
                                self.registerData.atmOrRekening = "ATM"
                                self.registerData.noAtm = self.noKartuCtrl
                                
                                self.registerData.accType = "ATM"
                                self.registerData.accNo = self.noKartuCtrl
                            } else {
                                self.registerData.atmOrRekening = "REKENING"
                                self.registerData.noRekening = self.noKartuCtrl
                                
                                self.registerData.accType = "REKENING"
                                self.registerData.accNo = self.noKartuCtrl
                            }
                            self.isActive = true
                        }, label: {
                            Text("Verification Card No.".localized(language))
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 50)
                        })
                        .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.bottom, 30)
                        .disabled(disableForm)
                        
                        NavigationLink(
                            destination: PhoneOTPRegisterNasabahView(rootIsActive: self.$rootIsActive, root2IsActive: self.$isActive).environmentObject(registerData),
                            isActive: self.$isActive,
                            label: {EmptyView()})
                            .isDetailLink(false)
                    }
                }
                .padding(.horizontal,30)
                .frame(width: UIScreen.main.bounds.width - 40)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.vertical, 25)
            }
            
            if (self.isShowAlertInternetConnection) {
                ModalOverlay(tapAction: { withAnimation {
                    self.isShowAlertInternetConnection = false
                } })
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.registerData.isNasabahmestika = true
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
    }
    
    func PopupNoInternetConnection() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Please check your internet connection".localized(language))
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(
                action: {
                    self.isShowAlertInternetConnection = false
                    self.appState.moveToWelcomeView = true
                },
                label: {
                    Text("OK".localized(language))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
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
    
    func isNetworkReachability(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        
        let canConnectWithoutInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutInteraction)
    }
}

struct RegisterRekeningCardView_Previews: PreviewProvider {
    static var previews: some View {
        NoAtmOrRekeningVerificationView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel()).environmentObject(AppState())
    }
}
