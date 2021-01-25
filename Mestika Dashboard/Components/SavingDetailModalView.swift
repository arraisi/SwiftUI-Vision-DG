//
//  SavingDetailModalView.swift
//  Mestika Dashboard
//
//  Created by Ismail Haq on 13/01/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SavingDetailModalView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var atmData: AddProductATM
    var data: JenisTabunganViewModel
    
    @Binding var isShowModalDetail: Bool
    
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
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Group {
                Text(NSLocalizedString("Produk Tabungan Mestika", comment: ""))
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color(hex: "#2334D0"))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Text(data.description)
                        .font(.footnote)
                        .padding(.top, 10)
                        .padding(.horizontal, 15)
                        .foregroundColor(Color(hex: "#5A6876"))
                    
                    //                    ForEach(data.description, id: \.id) { card in
                    //                        HStack(alignment: .top) {
                    //                            Text(card.id)
                    //                                .font(.custom("Montserrat-Regular", size: 12))
                    //                                .foregroundColor(Color(hex: "#232175"))
                    //                                .fontWeight(.bold)
                    //                                .frame(width: 25, height: 18)
                    //                            Text(card.desc)
                    //                                .font(.custom("Montserrat-Regular", size: 12))
                    //                                .foregroundColor(Color(hex: "#5A6876"))
                    //                                .frame(minHeight: 18)
                    //                            Spacer()
                    //                        }
                    //                        .padding(.top, 1)
                    //                        .padding(.horizontal, 15)
                    //                    }
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
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            
        }
    }
}

struct SavingDetailModalView_Previews: PreviewProvider {
    static var previews: some View {
        SavingDetailModalView(data: JenisTabunganViewModel(id: "id", name: "Name", description: "description", type: "type", codePlan: "codeplan"), isShowModalDetail: Binding.constant(false)).environmentObject(RegistrasiModel())
            .environmentObject(AddProductATM())
    }
}
