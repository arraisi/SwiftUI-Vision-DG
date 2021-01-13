//
//  DetailsTypeSavingView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 09/11/20.
//

import SwiftUI

struct DetailsTypeSavingView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    var data: SavingType
    @Binding var isShowModal: Bool
    @Binding var isShowModalDetail: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(data.tabunganName)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#3756DF"))
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(NSLocalizedString("Keunggulan Tabungan :", comment: ""))
                .font(.footnote)
                .padding(.top, 10)
                .padding(.horizontal, 15)
                .foregroundColor(Color(hex: "#5A6876"))
            
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {

                ForEach(data.description, id: \.id) { card in
                    HStack(alignment: .top) {
                        Text(card.id)
                            .font(.caption)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                            .frame(width: 25, height: 18)
                        Text(card.desc)
                            .font(.caption2)
                            .foregroundColor(Color(hex: "#5A6876"))
                            .frame(minHeight: 18)
                        Spacer()
                    }
                    .padding(.top, 1)
                    .padding(.horizontal, 15)
                }
            }
            .frame(height: 120)
            
            VStack(alignment: .trailing, spacing: nil, content: {
                Button(action: {
                    self.isShowModalDetail = true
                }, label: {
                    Text(NSLocalizedString("Saving Detail", comment: ""))
                        .foregroundColor(Color(hex: "#2334D0"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(minHeight: 30)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                })
            }).frame(maxWidth: .infinity, alignment: .trailing)
            
            Button(
                action: {
                    self.isShowModal = true
                },
                label: {
                    Text(NSLocalizedString("Pilih Tabungan ini", comment: ""))
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
        .background(Color.white)
    }
}

struct DetailsTypeSavingView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsTypeSavingView(data: SavingType(id: 1, tabunganName: "Tabungan Mestika Batik (TAMES BATIK)", rekeningNumber: "1234", imageName: "jt_tames_batik", isShow: false, description: [SavingTypeDescription(id: "01", desc: "Test 1"),SavingTypeDescription(id: "02", desc: "Test 2")]), isShowModal: Binding.constant(false), isShowModalDetail: Binding.constant(false)).environmentObject(RegistrasiModel())
    }
}
