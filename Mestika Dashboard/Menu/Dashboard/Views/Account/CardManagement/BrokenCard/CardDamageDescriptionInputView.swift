//
//  CardDamageDescriptionInputView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 03/03/21.
//

import SwiftUI

struct CardDamageDescriptionInputView: View {
    
    @EnvironmentObject var appState: AppState
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var cardData: BrokenKartuKuModel
    
    @State var cardNo: String = ""
    @State var pinAtm: String = ""
    
    /* Boolean for Show Modal */
    @State var showingModal = false
    @State var showingModalError = false
    
    @State var isLoading: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        atmForm
                            .padding(.top, 60)
                        
                        Button(action: {
                            UIApplication.shared.endEditing()
                            self.cardData.pin = self.pinAtm
                            brokenKartuKu()
                        }, label: {
                            Text("REPORT CARD DAMAGE")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color.gray : Color(hex: "#232175"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    }
                })
            }
            
            // Background Color When Modal Showing
            if self.showingModal || self.showingModalError {
                ModalOverlay(tapAction: { withAnimation { } })
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationBarTitle("Kerusakan Kartu", displayMode: .inline)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.cardNo = cardData.cardNo
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingModal, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popUpSucess()
        }
        .popup(isPresented: $showingModalError, type: .floater(verticalPadding: 60), position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: false) {
            popUpWrongPin()
        }
    }
    
    var atmForm: some View {
        VStack {
            // Field Pilih Bank
            VStack {
                HStack {
                    Text("Masukkan Kartu ATM")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 25)
                
                HStack {
                    TextField("Kartu ATM", text: self.$cardNo, onEditingChanged: { changed in
                        self.cardData.cardNo = self.cardNo
                    })
                    .disabled(true)
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .onReceive(cardNo.publisher.collect()) {
                        self.cardNo = String($0.prefix(16))
                    }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            }
            
            // Field No Rekening Tujuan
            VStack {
                HStack {
                    Text("Masukkan PIN ATM Anda")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                HStack {
                    SecureField("Pin ATM", text: self.$pinAtm)
                    .keyboardType(.numberPad)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .onReceive(pinAtm.publisher.collect()) {
                        self.pinAtm = String($0.prefix(6))
                    }
                }
                .background(Color(hex: "#F6F8FB"))
                .cornerRadius(10)
                .padding(.horizontal, 15)
                .padding(.bottom, 25)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding(.bottom)
        .padding(.top, 70)
    }
    
    var disableForm: Bool {
        if (self.cardNo.isNotEmpty() && self.pinAtm.isNotEmpty() && self.isLoading == false) {
            return false
        }
        return true
    }
    
    // MARK: - BOTTOM FLOATER FOR SUCCESS
    func popUpSucess() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("ic_plane")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(.top, 10)
            
            HStack {
                
                Text("We have successfully kept your ATM card damage report / complaint".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            
            HStack {
                Text("Thank you for sending information about the damage to your card to us. Please wait a few moments, we will immediately contact you to follow up on your report.".localized(language))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            Button(
                action: {
                    self.appState.moveToTransfer = true
                },
                label: {
                    Text("BACK".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
            .frame(height: 50)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 25)
        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - BOTTOM FLOATER FOR WRONG PIN
    func popUpWrongPin() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(Color(hex: "#F32424"))
                
                
                Text("Wrong ATM PIN".localized(language))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#F32424"))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.top, 25)
            
            HStack {
                Text("The ATM PIN you entered is wrong.".localized(language))
                    .font(.custom("Montserrat-Light", size: 12))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            Button(
                action: {
                    self.showingModalError = false
                },
                label: {
                    Text("Back".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                }
            )
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.top, 15)

        }
        .padding(25)
        .frame(width: UIScreen.main.bounds.width - 60)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    @ObservedObject var kartKuVM = KartuKuViewModel()
    func brokenKartuKu() {
        self.isLoading = true
        self.kartKuVM.brokenKartuKu(data: cardData) { success in
            if success {
                print("SUCCESS")
                self.isLoading = false
                self.showingModal = true
            }
            
            if !success {
                print("!SUCCESS")
                self.isLoading = false
                self.showingModalError = true
            }
        }
    }
}

struct CardDamageDescriptionInputView_Previews: PreviewProvider {
    static var previews: some View {
        CardDamageDescriptionInputView()
    }
}
