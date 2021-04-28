//
//  DestinationAccountBalancesView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI

struct MoveBalanceCard: Identifiable, Hashable {
    var id: Int
    var typeTabungan, saldo, cardNo: String
    var color: String
}

struct DestinationAccountBalancesView: View {
    
    // Observable Object
    @State var transaksiData = MoveBalancesModel()
    
    @State private var _listAccount = [
        MoveBalanceCard(id: 1, typeTabungan: "Platinum Saver", saldo: "300000", cardNo: "98391928391", color: "#2334D0"),
        MoveBalanceCard(id: 2, typeTabungan: "Gold Saver", saldo: "100000", cardNo: "98391928391", color: "#D0C423"),
        MoveBalanceCard(id: 3, typeTabungan: "Silver Saver", saldo: "150000", cardNo: "98391928391", color: "#9B9B9B")
    ]
    
    // Routing
    @State private var nextRouting: Bool = false
    
    var body: some View {
        ZStack {
            
            // Route Link
            NavigationLink(
                destination: FormMoveBalanceView().environmentObject(transaksiData),
                isActive: self.$nextRouting,
                label: {}
            )
            
            // bg color
            Color(hex: "#F4F7FA")
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                // title text
                VStack(alignment: .leading) {
                    Text("Pindah Saldo ke")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Silahkan pilih tabungan tujuan pemindahan saldo dari rekening utama")
                        .font(.subheadline)
                }
                .padding(.vertical, 20)
                
                // list account
                ForEach(self._listAccount, id: \.self) { data in
                    Button(action: {
                        
                        self.transaksiData.cardNo = data.cardNo
                        self.transaksiData.destinationNumber = "123456"
                        self.transaksiData.transferType = "Pindah Saldo"
                        self.transaksiData.destinationName = data.typeTabungan
                        self.transaksiData.sourceNumber = "123456"
                        self.transaksiData.sourceAccountName = "Rekening Utama"
                        
                        self.nextRouting = true
                        
                    }, label: {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Spacer()
                                Image("logo_m_mestika")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                            }
                            .padding(.trailing, 15)
                            
                            Text("\(data.typeTabungan)")
                                .fontWeight(.semibold)
                                .font(.system(size: 18))
                                .padding(.bottom, 5)
                            
                            HStack(alignment: .top) {
                                Text("Rp.")
                                    .fontWeight(.bold)
                                
                                Text("\(data.saldo.thousandSeparator())")
                                    .fontWeight(.heavy)
                                    .font(.system(size: 30))
                            }
                            .padding(.bottom, 5)
                            
                            Text("\(data.cardNo)")
                                .font(.system(size: 15))
                        }
                        .padding([.vertical, .leading], 15)
                        .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                        .background(Color(hex: "\(data.color)"))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    })
                }
            })
            .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Pindah Saldo", displayMode: .inline)
    }
}

struct DestinationAccountBalancesView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationAccountBalancesView()
    }
}
