//
//  OtpChangePinAtmView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct OtpChangePinAtmView: View {
    
    var maxDigits: Int = 6
    @State private var pin: String = ""
    @State private var showPin = true
    @State private var isDisabled = false
    
    @State private var isOtpValid = false
    @State private var otpInvalidCount = 0
    @State private var isResendOtpDisabled = true
    
    @State private var timeRemaining = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var disableForm: Bool {
        pin.count < 6
    }
    
    var nextView: AnyView
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Text("MASUKKAN KODE OTP")
                    .font(.custom("Montserrat-SemiBold", size: 24))
                    .foregroundColor(Color(hex: "#2334D0"))
                
                Text("Kami telah mengirimkan OTP ke no. telepon Anda")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#002251"))
                    .padding(.top, 5)
                
                ZStack {
                    pinDots
                    backgroundField
                }
                .padding(.top, 30)
                
                HStack {
                    Text("Tidak Menerima Kode?")
                        .font(.caption)
                        .fontWeight(.light)
                    
                    Button(action: {
                        print("-> Resend OTP")
                        self.timeRemaining = 60
                    }) {
                        Text("Resend OTP")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(isResendOtpDisabled ? Color.black : Color(hex: "#232175"))
                    }
                    .disabled(isResendOtpDisabled)
                    
                    Text("(00:\(timeRemaining))")
                        .font(.caption)
                        .fontWeight(.light)
                }
                .padding(.top, 5)
                
                Text("Pastikan Anda terkoneksi ke Internet dan pulsa mencukupi untuk menerima OTP")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#002251"))
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
                    .fixedSize(horizontal: false, vertical: true)
                
                NavigationLink(destination: AnyView(nextView), label: {
                    Text("Reset PIN Transaksi")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 16))
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(30)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("No. telepon Anda berubah?")
                                .font(.custom("Montserrat-Regular", size: 9))
                            Button(action: {
                                
                            }, label: {
                                Text("Input No. Telepon Baru Anda")
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                            })
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Ganti cara validasi?")
                                .font(.custom("Montserrat-Regular", size: 9))
                            Button(action: {
                                
                            }, label: {
                                Text("Kirim Kode/Link Verifikasi melalui Email")
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                            })
                        }
                    }
                    
                    Spacer()
                }
                .padding(30)
            }
            .padding(.top, 60)
            .onReceive(timer) { time in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
                
                if self.timeRemaining < 1 {
                    isResendOtpDisabled = false
                }
            }
            .navigationBarTitle("Reset PIN Transaksi", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {}, label: {
                Text("Cancel")
            }))
        }
    }
    
    var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits) { index in
                Text("\(self.getImageName(at: index))")
                    .font(.title)
                    .foregroundColor(Color(hex: "#232175"))
                    .bold()
                    .frame(width: 40, height: 40)
                    .multilineTextAlignment(.center)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
            }
            Spacer()
        }.onTapGesture(perform: {
            isDisabled = false
        })
    }
    
    var backgroundField: some View {
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

struct OtpChangePinAtmView_Previews: PreviewProvider {
    static var previews: some View {
        OtpChangePinAtmView(nextView: AnyView(FormNewPinAtmView(showingModal: true)))
    }
}
