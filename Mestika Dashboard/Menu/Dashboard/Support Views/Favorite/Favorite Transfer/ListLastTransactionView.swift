//
//  ListLastTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListLastTransactionView: View {
    
    var sourceNumber = ""
    @StateObject private var favoritVM = FavoritViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text("Transaksi Terakhir")
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                    .padding(.bottom, 20)
                
                ForEach(self.favoritVM.lastTransaction, id: \.trace) { data in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 30, height: 30)
                            
                            Text("B")
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(data.date.subStringRange(from: 6, to: 8)) - \(data.date.subStringRange(from: 4, to: 6)) - \(data.date.subStringRange(from: 0, to: 4))")
                                .font(.caption2)
                            
                            Text("\(data.historyListDescription)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("- Rp.")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            
                            Text("\(data.amount.thousandSeparator())")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        
                        
                    }
                    .padding(.vertical, 5)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 60)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
            }
            .padding(.bottom)
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .onAppear {
            getList()
        }
    }
    
    func getList() {
        self.favoritVM.getListLastTransaction(sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
}

struct ListLastTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListLastTransactionView()
    }
}
