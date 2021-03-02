//
//  ListHistoryTransferView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import SwiftUI

struct ListHistoryTransferView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    

    @State var _listHistory = [
        HistoryTransfer(id: 1, tanggalTransaksi: "20 September 2020", jenisTransaksi: "in", nilaiTransaksi: "600.000", username: "BAMBANNG P", namaBank: "BCA", norek: "990787871282"),
        HistoryTransfer(id: 2, tanggalTransaksi: "1 Oktober 2020", jenisTransaksi: "in", nilaiTransaksi: "530.000", username: "ANJASMARA", namaBank: "BNI", norek: "09989128389"),
        HistoryTransfer(id: 3, tanggalTransaksi: "2 Oktober 2020", jenisTransaksi: "out", nilaiTransaksi: "305.000", username: "GANJAR H", namaBank: "MESTIKA", norek: "908712839313"),
        HistoryTransfer(id: 4, tanggalTransaksi: "10 Oktober 2020", jenisTransaksi: "in", nilaiTransaksi: "1.000.000", username: "HENDRI A", namaBank: "MESTIKA", norek: "88989120892"),
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                HStack {
                    Text(NSLocalizedString("Transfer History".localized(language), comment: ""))
                        .foregroundColor(Color(hex: "#1D2238"))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text(NSLocalizedString("More".localized(language), comment: ""))
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.caption2)
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.horizontal, 10)
                
                List(0..._listHistory.count - 1, id: \.self) { index in
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
                            Text("\(_listHistory[index].tanggalTransaksi)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.caption)
                                .fontWeight(.ultraLight)
                            
                            Text("\(_listHistory[index].username)")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                            
                            HStack {
                                Text("\(_listHistory[index].namaBank) :")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                
                                Text("\(_listHistory[index].norek)")
                                    .foregroundColor(Color(hex: "#1D2238"))
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        }
                        
                        Spacer()
                        
                        if (_listHistory[index].jenisTransaksi == "in") {
                            HStack {
                                Text("- Rp.")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                                
                                Text("\(_listHistory[index].nilaiTransaksi)")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        } else {
                            HStack {
                                Text("- Rp.")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                
                                Text("\(_listHistory[index].nilaiTransaksi)")
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                .colorMultiply(Color(hex: "#F6F8FB"))
                .frame(height: 300)
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
    }
}

struct ListHistoryTransferView_Previews: PreviewProvider {
    static var previews: some View {
        ListHistoryTransferView()
    }
}
