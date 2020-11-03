//
//  ListMySavingsView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct ListMySavingsView: View {
    
    @State var _listMySavings = [
        MySavings(id: 1, namaRekening: "Rekening Utama", norek: "89098192389", saldo: "350.000"),
        MySavings(id: 2, namaRekening: "Rekening 2", norek: "9090989812", saldo: "0.0"),
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Tabungan Ku")
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("detail selengkapnya")
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                
                ForEach(0..._listMySavings.count - 1, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(_listMySavings[index].namaRekening)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                            
                            Text("\(_listMySavings[index].norek)")
                                .font(.caption)
                                .fontWeight(.ultraLight)
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            Text("Rp.")
                                .font(.caption)
                                .fontWeight(.bold)
                            Text("\(_listMySavings[index].saldo)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "#1D2238"))
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ListMySavingsView_Previews: PreviewProvider {
    static var previews: some View {
        ListMySavingsView()
    }
}
