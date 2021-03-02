//
//  VerificationAddressView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct VerificationAddressView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var registerData: RegistrasiModel
    @State var isShowNextView : Bool = false
    
    @State var addressInput: String = ""
    @State var addressRtRwInput: String = ""
    @State var addressKelurahanInput: String = ""
    @State var addressKecamatanInput: String = ""
    @State var addressKodePosInput: String = ""
    
    let verificationAddress: [MasterModel] = load("verificationAddress.json")
    
    /* Variable for Swipe Gesture to Back */
    @GestureState private var dragOffset = CGSize.zero
    @State var isShowingAlert: Bool = false
    
    var disableForm: Bool {
        
        if (registerData.verificationAddressId == 0) {
            return true
        }
        
        if (registerData.verificationAddressId != 1) {
            if registerData.addressInput.isEmpty || addressInput.isEmpty || addressRtRwInput.isEmpty || addressKelurahanInput.isEmpty || addressKecamatanInput.isEmpty || addressKodePosInput.isEmpty {
                return true
            }
        } 
        
        return false
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var showingModal = false
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var messageResponse: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack(spacing: 0) {
                
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    VStack {
                        Text(NSLocalizedString("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language), comment: ""))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .center) {
                            Text(NSLocalizedString("Does Your Mailing Address Match Your Identity Card/(KTP)?".localized(language), comment: ""))
                                .font(.title2)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            
                            ZStack {
                                
                                RadioButtonGroup(
                                    items: verificationAddress,
                                    selectedId: $registerData.verificationAddressId) { selected in
                                    print("Selected is: \(selected)")
                                    
                                    if (selected == 1) {
                                        registerData.isAddressEqualToDukcapil = true
                                    } else if (selected == 2) {
                                        registerData.isAddressEqualToDukcapil = false
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 15)
                                .padding(.bottom, 20)
                                
                            }
                            
                            if (registerData.verificationAddressId == 1 || registerData.verificationAddressId == 0) {
                                EmptyView()
                            } else {
                                
                                Group {
                                    Divider()
                                        .padding(.horizontal, 20)
                                    
                                    //                                    LabelTextField(value: $addressInput, label: NSLocalizedString("Alamat", comment: ""), placeHolder: NSLocalizedString("Alamat", comment: ""), onEditingChanged: { (Bool) in
                                    //                                        print("on edit")
                                    //                                        registerData.addressInput = self.addressInput
                                    //                                    }, onCommit: {
                                    //                                        print("on commit")
                                    //                                        registerData.addressInput = self.addressInput
                                    //                                    })
                                    //                                    .padding(.horizontal, 20)
                                    
                                    Group {
                                        HStack {
                                            Text(NSLocalizedString("Address".localized(language), comment: ""))
                                                .font(Font.system(size: 12))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(hex: "#707070"))
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            
                                            TextField(NSLocalizedString("Address".localized(language), comment: ""), text: $registerData.addressInput) { changed in
                                            } onCommit: {
                                                self.addressInput = self.registerData.addressInput
                                            }
                                            .font(Font.system(size: 14))
                                            .frame(height: 36)
                                            .padding(.horizontal)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10)
                                            
                                            Button(action:{
                                                //                        showingModal.toggle()
                                                searchAddress()
                                            }, label: {
                                                Image(systemName: "magnifyingglass")
                                                    .font(Font.system(size: 20))
                                                    .foregroundColor(Color(hex: "#707070"))
                                            })
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    
                                    LabelTextField(value: $addressRtRwInput, label: "RT/RW", placeHolder: "RT/RW", onEditingChanged: { (Bool) in
                                        print("on edit")
                                        registerData.addressRtRwInput = self.addressRtRwInput
                                    }, onCommit: {
                                        print("on commit")
                                        registerData.addressRtRwInput = self.addressRtRwInput
                                    })
                                    .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $addressKelurahanInput, label: NSLocalizedString("Village".localized(language), comment: ""), placeHolder: NSLocalizedString("Village".localized(language), comment: ""), onEditingChanged: { (Bool) in
                                        print("on edit")
                                        registerData.addressKelurahanInput = self.addressKelurahanInput
                                    }, onCommit: {
                                        print("on commit")
                                        registerData.addressKelurahanInput = self.addressKelurahanInput
                                    })
                                    .padding(.horizontal, 20)
                                    
                                    LabelTextField(value: $addressKecamatanInput, label: NSLocalizedString("Sub-district".localized(language), comment: ""), placeHolder: NSLocalizedString("Sub-district".localized(language), comment: ""), onEditingChanged: { (Bool) in
                                        print("on edit")
                                        registerData.addressKecamatanInput = self.addressKecamatanInput
                                    }, onCommit: {
                                        print("on commit")
                                        registerData.addressKecamatanInput = self.addressKecamatanInput
                                    })
                                    .padding(.horizontal, 20)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(NSLocalizedString("Postal code".localized(language), comment: ""))
                                            .font(Font.system(size: 12))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#707070"))
                                        
                                        HStack {
                                            TextField(NSLocalizedString("Postal code".localized(language), comment: ""), text: $addressKodePosInput) { change in
                                            } onCommit: {
                                                print("on commit")
                                                registerData.addressPostalCodeInput = self.addressKodePosInput
                                            }
                                            .onReceive(addressKodePosInput.publisher.collect()) {
                                                self.addressKodePosInput = String($0.prefix(5))
                                            }
                                            .keyboardType(.numberPad)
                                            .font(Font.system(size: 14))
                                            .frame(height: 36)
                                        }
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 30)
                                }
                            }
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                }
                
                VStack {
                    NavigationLink(destination: PasswordView().environmentObject(registerData), isActive: self.$isShowNextView) {EmptyView()}
                    
                    
                    Button(action: {
                        
                        self.isShowNextView = true
                        
                    }, label: {
                        Text(NSLocalizedString("Submit Data".localized(language), comment: ""))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .disabled(disableForm)
                    .background(Color(hex: disableForm ? "#CBD1D9" : "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                }
                .background(Color.white)
            }
        }
        .KeyboardAwarePadding()
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .alert(isPresented: $isShowingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Do you want to cancel registration?".localized(language), comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YES".localized(language), comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("NO".localized(language), comment: ""))))
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            addressSuggestionPopUp()
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.isShowingAlert = true
            }
        }))
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func addressSuggestionPopUp() -> some View {
        VStack {
            HStack {
                Text(NSLocalizedString("Address".localized(language), comment: ""))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField(NSLocalizedString("Address".localized(language), comment: ""), text: $addressInput)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    searchAddress(keyword: addressInput)
                }, label: {
                    Image(systemName: "location")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            ScrollView {
                VStack {
                    ForEach(addressSugestionResult, id: \.formatted_address) {data in
                        Button(action: {
                            searchAddress(data: data.formatted_address)
                            self.showingModal.toggle()
                        }) {
                            VStack {
                                HStack{
                                    Text(data.formatted_address)
                                    Spacer()
                                }
                                Divider()
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .frame(height: 150)
            .padding(.vertical)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - SEARCH LOCATION
    @ObservedObject var addressVM = AddressSummaryViewModel()
    func searchAddress(keyword: String? = nil) {
        self.isLoading = true
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? registerData.addressInput) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestionResult = self.addressVM.addressResult
                self.showingModal = true
                print("Success")
                print("addressSugestionResult => \(self.addressSugestionResult[0])")
            }
            
            if !success {
                self.isLoading = self.addressVM.isLoading
                self.isShowAlert = true
                self.messageResponse = self.addressVM.message
                print("Not Found")
            }
        }
    }
    
    // MARK: - SEARCH LOCATION COMPLETION
    func searchAddress(data: String) {
        self.isLoading = true
        
        self.addressVM.getAddressSugestion(addressInput: data) { success in
            if success {
                self.isLoading = self.addressVM.isLoading
                self.addressSugestion = self.addressVM.address
                DispatchQueue.main.async {
                    registerData.addressInput = self.addressSugestion[0].formatted_address
                    registerData.addressPostalCodeInput = self.addressSugestion[0].postalCode
                    registerData.addressKecamatanInput = self.addressSugestion[0].kecamatan
                    registerData.addressKelurahanInput = self.addressSugestion[0].kelurahan
                    registerData.addressRtRwInput = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                    
                    self.addressInput = self.addressSugestion[0].formatted_address
                    self.addressRtRwInput = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                    self.addressKelurahanInput = self.addressSugestion[0].kelurahan
                    self.addressKecamatanInput = self.addressSugestion[0].kecamatan
                    self.addressKodePosInput = self.addressSugestion[0].postalCode
                }
                self.showingModal = false
                print("Success")
                print("self.addressSugestion[0].postalCode => \(self.addressSugestion[0].postalCode)")
            }
            
            if !success {
                self.isLoading = self.addressVM.isLoading
                self.isShowAlert = true
                self.messageResponse = self.addressVM.message
                print("Not Found")
            }
        }
    }
}

struct VerificationAddressView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationAddressView().environmentObject(RegistrasiModel())
    }
}
