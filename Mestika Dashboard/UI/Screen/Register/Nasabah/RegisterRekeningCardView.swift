//
//  RegisterRekeningCardView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI

struct RegisterRekeningCardView: View {
    
    @State var jenisKartu: String = ""
    @State var noKartu: String = ""
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            VStack {
                appbar
                    .padding(.top, 45)
                    .padding(.horizontal, 30)
                
                VStack {
                    cardForm
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 35)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
    }
    
    var appbar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
            Spacer()
            logo
            Spacer()
        }
    }
    
    var cardForm: some View {
        VStack(alignment: .center) {
            Text("No. Kartu ATM atau Rekening")
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            Text("Silahkan masukan no kartu ATM atau Rekening anda")
                .font(.subheadline)
                .foregroundColor(Color(hex: "#232175"))
                .multilineTextAlignment(.center)
                .padding(.top, 5)
                .padding(.horizontal, 20)
            TextField("Pilih jenis no Kartu yang diinput", text: $jenisKartu)
                .frame(height: 10)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.bottom, 5)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            TextField("Masukan no kartu", text: $noKartu)
                .frame(height: 10)
                .font(.subheadline)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            Text("*Pastikan kartu ATM atau Rekening Anda telah aktif, jika belum aktifasi kartu ATM silahkan kunjungi Kantor Bank Mestika terdekat.")
                .font(.caption2)
                .padding(.top, 5)
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            Button(action : {}) {
                Text("Verifikasi No. Telepon")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .offset(y: kGuardian.slide).animation(.easeInOut(duration: 1.0))
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 30)
    }
    
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("Logo M")
                .resizable()
                .frame(width: 25, height: 25)
            Text("BANK MESTIKA")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .bold()
        }
    }
}

struct RegisterRekeningCardView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterRekeningCardView()
    }
}
