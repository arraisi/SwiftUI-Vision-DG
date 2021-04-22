//
//  PesanView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 22/04/21.
//

import SwiftUI

struct PesanView: View {
    
    private var inbox = PesanModel.all()
    
    var body: some View {
        List {
            
            ForEach(inbox, id: \.self) { data in
                
                Section(header: Text(data.date)) {
                    
                    ForEach(data.pesan, id: \.self){ p in
                        PesanRow(p: p)
                    }
                    
                }
                
            }
            
        }
        .listStyle(GroupedListStyle())
    }
}

struct PesanRow: View {
    
    var p: PesanItemModel
    
    var body: some View {
        HStack {
            
            Image(systemName: p.iconName)
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 35, height: 35, alignment: .center)
            
            VStack(alignment: .leading) {
                Text(statusText(p.status))
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(statusColor(p.status))
                Text(p.pesan)
                    .font(.system(size: 18))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("DarkStaleBlue"))
                HStack(spacing: 2) {
                    Text(p.date)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Text("Transaksi sebesar")
                        .font(.system(size: 10))
                        .fontWeight(.regular)
                    Text("Rp. \(p.transaksi.thousandSeparator())")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    func statusText(_ status: String) -> String {
        switch status {
        case "Berhasil":
            return "Transaksi Berhasil"
        case "Gagal":
            return "Transaksi Gagal"
        case "Schedule":
            return "Transaksi On Schedule"
        default:
            return "-"
        }
    }
    
    func statusColor(_ status: String) -> Color {
        switch status {
        case "Berhasil":
            return Color.green
        case "Gagal":
            return Color.red
        case "Schedule":
            return Color.blue
        default:
            return Color.black
        }
    }
}

struct PesanView_Previews: PreviewProvider {
    static var previews: some View {
        PesanView()
    }
}
