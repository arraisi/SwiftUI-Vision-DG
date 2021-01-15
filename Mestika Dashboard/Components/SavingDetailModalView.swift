//
//  SavingDetailModalView.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 13/01/21.
//

import SwiftUI

struct SavingDetailModalView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var atmData: AddProductATM
    var data: SavingType
    
    @Binding var isShowModalDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Image(data.imageName)
                    .resizable()
                    .frame(height: 200)
                
                Text(NSLocalizedString("Produk Tabungan Mestika", comment: ""))
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color(hex: "#2334D0"))
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView {

                    ForEach(data.description, id: \.id) { card in
                        HStack(alignment: .top) {
                            Text(card.id)
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.bold)
                                .frame(width: 25, height: 18)
                            Text(card.desc)
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#5A6876"))
                                .frame(minHeight: 18)
                            Spacer()
                        }
                        .padding(.top, 1)
                        .padding(.horizontal, 15)
                    }
                }
                .frame(minHeight: 80, maxHeight: 200)
            }
            
            Button(action: {
                
                withAnimation {
                    self.isShowModalDetail.toggle()
                }
                
            }) {
                Text(NSLocalizedString("Kembali", comment: ""))
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
    }
}

struct SavingDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        SavingDetailModalView(data: SavingType(id: 1, tabunganName: "Tabungan Mestika Batik (TAMES BATIK)", rekeningNumber: "1234", imageName: "jt_tabungan_simpel", isShow: false, description: [SavingTypeDescription(id: "01", desc: "Test 1"),SavingTypeDescription(id: "02", desc: "Test 2")]), isShowModalDetail: Binding.constant(false)).environmentObject(RegistrasiModel())
            .environmentObject(AddProductATM())
    }
}
