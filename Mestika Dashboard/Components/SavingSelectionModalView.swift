//
//  SavingSelectionModalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 25/09/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavingSelectionModalView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var atmData: AddProductATM
    var data: JenisTabunganViewModel
    
    @Binding var editMode: EditMode
    @Binding var isShowModal: Bool
    @Binding var showingReferralCodeModal: Bool
    @Binding var goToNextPage: Bool
    @Binding var backToSummary: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: data.image)
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .placeholder {
                    Rectangle().foregroundColor(.gray).opacity(0.5)
                }
                .resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                //                    .scaledToFill()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Spacer()
            
            VStack {
                Text("Anda Telah memilih")
                    .font(.custom("Montserrat-Regular", size: 14))
                    .padding(.horizontal, 20)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Text(data.name)
                    .font(.custom("Montserrat-Regular", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2334D0"))
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
            
            VStack(alignment: .center) {
                Text("Punya kode referal ?")
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                TextField(NSLocalizedString("Masukkan kode referal", comment: ""), text: $atmData.atmAddresspostalReferral, onEditingChanged: { changed in
                }, onCommit: {})
                .frame(height: 20)
                .font(.custom("Montserrat-Regular", size: 14))
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .multilineTextAlignment(TextAlignment.center)
                
                Text(NSLocalizedString("Pastikan kamu memasukkan kode refferalmu dengan benar.", comment: ""))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(TextAlignment.center)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            
            VStack(alignment: .center, spacing: 10){
                Button(action: {
                    registerData.jenisTabungan = data.name
                    
                    withAnimation {
                        self.isShowModal.toggle()
                    }
                    
                    //                self.showingReferralCodeModal = true
                    if (editMode == .inactive) {
                        goToNextPage = true
                    } else {
                        backToSummary = true
                    }
                    
                }) {
                    Text(NSLocalizedString("Pilih Tabungan Ini", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Button(action: {
                    
                    withAnimation {
                        self.isShowModal.toggle()
                    }
                    
                }) {
                    Text(NSLocalizedString("Pilih Tabungan lain", comment: ""))
                        .foregroundColor(Color(hex: "#5A6876"))
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                }
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 100)
    }
}
