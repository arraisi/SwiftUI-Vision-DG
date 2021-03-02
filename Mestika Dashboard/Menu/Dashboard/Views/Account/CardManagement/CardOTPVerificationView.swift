//
//  VerificationOTPCardView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 04/11/20.
//

import SwiftUI

struct CardOTPVerificationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var otp = "123456"
    var card: MyCard
    
    /*
     Variable PIN OTP
     */
    var maxDigits: Int = 6
    @State var pin: String = ""
    @State var showPin = true
    @State var isDisabled = false
    
    /*
     Variable Validation
     */
    @State var isOtpValid = false
    @State var otpInvalidCount = 0
    @State var isResendOtpDisabled = true
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false
    
    /*
     Timer
     */
    @State private var timeRemaining = 40
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(NSLocalizedString("OTP CODE VERIFICATION".localized(language), comment: ""))
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                CardForms
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 35)
        }
        .navigationBarTitle(NSLocalizedString("Activate Card".localized(language), comment: ""))
    }
    
    // MARK: - CARD FORMS
    var CardForms: some View {
        VStack(alignment: .center) {
            HStack {
                VStack(alignment: .center) {
                    Text(NSLocalizedString("Enter the OTP code has been sent to your number to continue to the next stage".localized(language), comment: ""))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            
            ZStack {
                pinDots
                backgroundField
            }
            
            HStack {
                Text(NSLocalizedString("Didn't Receive Code?".localized(language), comment: ""))
                    .font(.caption2)
                    .foregroundColor(.white)
                Button(action: {
                    print("-> Resend OTP")
                }) {
                    Text(NSLocalizedString("Resend OTP".localized(language), comment: ""))
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Text("(00:\(timeRemaining))")
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            .padding(.top, 5)
            
            Text(NSLocalizedString("Make sure you are connected to the Internet and have sufficient credit to receive OTP".localized(language), comment: ""))
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 15)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            NavigationLink(destination: CardCVVVerificationView(card: card), isActive: $isOtpValid) {
                Text("")
            }
            
            Button(
                action: {
                    if pin == otp {
                        isOtpValid.toggle()
                    } else {
                        pin = ""
                    }
                },
                label: {
                    Text(NSLocalizedString("ENTER OTP CODE".localized(language), comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 16))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                })
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 10)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    // MARK: - PIN DOTS
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0 ..< maxDigits) { index in
                Text("\(self.getImageName(at: index))")
                    .font(.title)
                    .foregroundColor(Color(hex: "#232175"))
                    .bold()
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
            }
            Spacer()
        }.onTapGesture(perform: {
            isDisabled = false
        })
    }
    
    // MARK: - BACKGROUND PIN DOTS
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return TextField("", text: boundPin, onCommit: submitPin)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .disabled(isDisabled)
    }
    
    private func submitPin() {
        if pin.count == maxDigits {
            isDisabled = true
        }
        
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getImageName(at index: Int) -> String {
        if index >= self.pin.count {
            return "•"
        }
        
        if self.showPin {
            return self.pin.digits[index].numberString
        }
        
        return ""
    }
}

struct CardOTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        CardOTPVerificationView(card: myCardData[0])
    }
}
