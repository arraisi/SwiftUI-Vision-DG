//
//  CardDamageAddressInputView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/03/21.
//

import SwiftUI

struct CardDamageAddressInputView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var cardData: BrokenKartuKuModel
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    @State var addressInput: String = ""
    @State var addressRtRwInput: String = ""
    @State var addressKelurahanInput: String = ""
    @State var addressKecamatanInput: String = ""
    @State var addressKodePosInput: String = ""
    
    @State var addressSugestion = [AddressViewModel]()
    @State var addressSugestionResult = [AddressResultViewModel]()
    
    @State var showingModal = false
    
    @State var isLoading: Bool = false
    @State private var isShowAlert: Bool = false
    
    @State var isRoute: Bool = false
    
    @State var messageResponse: String = ""
    
    var disableForm: Bool {
        if cardData.addressInput.isEmpty || addressInput.isEmpty || addressRtRwInput.isEmpty || addressKelurahanInput.isEmpty || addressKecamatanInput.isEmpty || addressKodePosInput.isEmpty {
            return true
        }
        
        return false
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack {
                        Text("MAKE SURE YOUR INFORMATION IS CORRECT".localized(language))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .center) {
                            Text("Make sure your correspondence address is correct".localized(language))
                                .font(.title2)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                            
                            Group {
                                Divider()
                                    .padding(.horizontal, 20)
                                
                                Group {
                                    HStack {
                                        Text("Address".localized(language))
                                            .font(Font.system(size: 12))
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#707070"))
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        
                                        TextField("Address".localized(language), text: $cardData.addressInput) { changed in
                                        } onCommit: {
                                            self.addressInput = self.cardData.addressInput
                                        }
                                        .font(Font.system(size: 14))
                                        .frame(height: 36)
                                        .padding(.horizontal)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                        Button(action:{
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
                                    cardData.addressRtRwInput = self.addressRtRwInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressRtRwInput = self.addressRtRwInput
                                })
                                .padding(.horizontal, 20)
                                
                                LabelTextField(value: $addressKelurahanInput, label: "Village".localized(language), placeHolder: "Village".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressKelurahanInput = self.addressKelurahanInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressKelurahanInput = self.addressKelurahanInput
                                })
                                .padding(.horizontal, 20)
                                
                                LabelTextField(value: $addressKecamatanInput, label: "Sub-district".localized(language), placeHolder: "Sub-district".localized(language), onEditingChanged: { (Bool) in
                                    print("on edit")
                                    cardData.addressKecamatanInput = self.addressKecamatanInput
                                }, onCommit: {
                                    print("on commit")
                                    cardData.addressKecamatanInput = self.addressKecamatanInput
                                })
                                .padding(.horizontal, 20)
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Postal code".localized(language))
                                        .font(Font.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(hex: "#707070"))
                                    
                                    HStack {
                                        TextField("Postal code".localized(language), text: $addressKodePosInput) { change in
                                        } onCommit: {
                                            print("on commit")
                                            cardData.addressPostalCodeInput = self.addressKodePosInput
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
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 100)
                    .padding(.bottom, 10)
                }
                
                NavigationLink(
                    destination: CardDamageDescriptionInputView().environmentObject(cardData),
                    isActive: self.$isRoute,
                    label: {
                        EmptyView()
                    })
                    .isDetailLink(false)
                
                VStack {
                    Button(action: {
                        self.isRoute = true
                    }, label: {
                        Text("Submit Data".localized(language))
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
        .navigationBarTitle("Broken Card".localized(language), displayMode: .inline)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print("ON APPEAR")
            //            user.forEach { data in
            //                print(data.addressInput!)
            //                cardData.addressInput = data.addressInput!
            //                cardData.addressPostalCodeInput = data.kodePosKeluarga!
            //                cardData.addressKecamatanInput = data.addressKecamatanInput!
            //                cardData.addressKelurahanInput = data.addressKelurahanInput!
            //                cardData.addressRtRwInput = "02 / 03"
            //
            //                self.addressInput = data.addressInput!
            //                self.addressRtRwInput = "02 / 03"
            //                self.addressKelurahanInput = data.addressKelurahanInput!
            //                self.addressKecamatanInput = data.addressKecamatanInput!
            //                self.addressKodePosInput = data.kodePosKeluarga!
            //            }
            //            getProfile()
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            addressSuggestionPopUp()
        }
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    func addressSuggestionPopUp() -> some View {
        VStack {
            HStack {
                Text("Address".localized(language))
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Address".localized(language), text: $addressInput)
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
        
        self.addressVM.getAddressSugestionResult(addressInput: keyword ?? cardData.addressInput) { success in
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
    
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.isLoading = true
        self.profileVM.getProfile { success in
            if success {
                print(self.profileVM.limitOnUs)
                self.isLoading = false
                
                cardData.addressInput = self.profileVM.alamat
                cardData.addressPostalCodeInput = ""
                cardData.addressKecamatanInput = self.profileVM.kecamatanName
                cardData.addressKelurahanInput = self.profileVM.kelurahanName
                cardData.addressRtRwInput = "\(self.profileVM.rt) / \(self.profileVM.rw)"
                
                self.addressInput = self.profileVM.alamat
                self.addressRtRwInput = "\(self.profileVM.rt) / \(self.profileVM.rw)"
                self.addressKelurahanInput = self.profileVM.kelurahanName
                self.addressKecamatanInput = self.profileVM.kecamatanName
                self.addressKodePosInput = ""
            }
            
            if !success {
                self.isLoading = false
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
                    cardData.addressInput = self.addressSugestion[0].formatted_address
                    cardData.addressPostalCodeInput = self.addressSugestion[0].postalCode
                    cardData.addressKecamatanInput = self.addressSugestion[0].kecamatan
                    cardData.addressKelurahanInput = self.addressSugestion[0].kelurahan
                    cardData.addressRtRwInput = "\(self.addressSugestion[0].rt) / \(self.addressSugestion[0].rw)"
                    
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

struct CardDamageAddressInputView_Previews: PreviewProvider {
    static var previews: some View {
        CardDamageAddressInputView().environmentObject(CardBrokenModel())
    }
}
