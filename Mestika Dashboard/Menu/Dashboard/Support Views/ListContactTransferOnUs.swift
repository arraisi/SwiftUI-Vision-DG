//
//  ListContactTransferOnUs.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct ListContactTransferOnUs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    var _listContact = [
        ContactTransferOnUs(id: 1, username: "Prima Jatnika", namaBank: "BNI", norek: "89898912383"),
        ContactTransferOnUs(id: 2, username: "Ilmal Yakin", namaBank: "BNI", norek: "1212312333"),
        ContactTransferOnUs(id: 3, username: "M. Yusuf", namaBank: "BCA", norek: "90909021333"),
        ContactTransferOnUs(id: 4, username: "Abdul Arraisi", namaBank: "BRI", norek: "89899899812")
    ]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Transfer")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("Money transfers to fellow Bank Mestika customers or to other Bank customers are now easier and faster.".localized(language))
                        .font(.caption)
                        .fontWeight(.ultraLight)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Image("ic_money_transfer")
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            
            HStack {
                Text("Transfer to".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Find another contract".localized(language))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#2334D0"))
                })
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
            List {
                ForEach(_listContact) { data in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: 30, height: 30)
                            
                            Text("A")
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(data.username)")
                                .font(.subheadline)
                            
                            HStack {
                                Text("\(data.namaBank) :")
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                                Text("\(data.norek)")
                                    .font(.caption)
                                    .fontWeight(.ultraLight)
                            }
                        }
                    }.padding(.vertical, 5)
                }
            }.frame(height: 300)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        
    }
}

struct ListContactTransferOnUs_Previews: PreviewProvider {
    static var previews: some View {
        ListContactTransferOnUs()
    }
}
