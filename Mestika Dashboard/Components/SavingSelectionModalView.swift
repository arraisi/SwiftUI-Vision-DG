//
//  SavingSelectionModalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 25/09/20.
//

import SwiftUI

struct SavingSelectionModalView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var atmData: AddProductATM
    var data: SavingType
    
    @Binding var editMode: EditMode
    @Binding var isShowModal: Bool
    @Binding var showingReferralCodeModal: Bool
    @Binding var goToNextPage: Bool
    @Binding var backToSummary: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Image(data.imageName)
                    .resizable()
                    .frame(height: 200)
                    .padding()
                
                Text("Anda Telah memilih")
                    .font(.custom("Montserrat-Regular", size: 18))
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(data.tabunganName)
                    .font(.custom("Montserrat-Regular", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2334D0"))
                    .padding(.horizontal, 15)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text("Punya kode referal ?")
                    .font(.custom("Montserrat-Regular", size: 18))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                TextField(NSLocalizedString("Masukkan kode referal", comment: ""), text: $atmData.atmAddresspostalReferral, onEditingChanged: { changed in
                }, onCommit: {})
                .frame(height: 20)
                .font(.custom("Montserrat-Regular", size: 14))
                .autocapitalization(.none)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(.horizontal, 15)
                .multilineTextAlignment(TextAlignment.center)
                
                Text(NSLocalizedString("Pastikan kamu memasukkan kode refferalmu dengan benar.", comment: ""))
                    .font(.custom("Montserrat-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                
            }
            
            Button(action: {
                registerData.jenisTabungan = data.tabunganName
                
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
            .padding(.horizontal, 15)
            .padding(.top, 30)
            
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
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            .padding(.top, 5)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
    }
}

struct SavingSelectionModalView_Previews: PreviewProvider {
    static var previews: some View {
        SavingSelectionModalView(data: SavingType(id: 1, tabunganName: "Tabungan Mestika Batik (TAMES BATIK)", rekeningNumber: "1234", imageName: "jt_tabungan_simpel", isShow: false, description: [SavingTypeDescription(id: "01", desc: "Test 1"),SavingTypeDescription(id: "02", desc: "Test 2")]), editMode: .constant(.inactive), isShowModal: Binding.constant(false), showingReferralCodeModal: .constant(false), goToNextPage: Binding.constant(false), backToSummary: .constant(false)).environmentObject(RegistrasiModel())
            .environmentObject(AddProductATM())
    }
}
