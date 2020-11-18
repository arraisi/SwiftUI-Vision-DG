//
//  ListNotificationView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 16/11/20.
//

import SwiftUI

struct ListNotificationView: View {
    @State var _listHistory = [
        NotificationMonthly(id: 1, month: "November 2020", list:[
            NotificationModel(id: 1, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - November - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000"),
            NotificationModel(id: 2, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - November - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000"),
            NotificationModel(id: 3, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - November - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000")
        ]),
        NotificationMonthly(id: 2, month: "Oktober 2020", list:[
            NotificationModel(id: 5, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - Oktober - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000"),
            NotificationModel(id: 6, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - Oktober - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000"),
            NotificationModel(id: 7, type: "Transfer", status: "Berhasil", title: "RTGS", time: "02 - Oktober - 2020", destinationAccount: "Mandiri - 320000288188211", amount: "100000")
        ])
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Tandai Semua Telah Dibaca")
                            .foregroundColor(Color("DarkStaleBlue"))
                            .font(.caption2)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 20))
                    }
                }
                List {
                    ForEach(_listHistory) { month in
                        Section(header: ListHeader(title: month.month)) {
                            ForEach(month.list) { item in
                                HStack {
                                    ZStack {
                                        Image("ic_notif_transfer")
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(item.type) \(item.status)")
                                            .foregroundColor(Color("Green"))
                                            .font(.system(size: 10))
                                            .fontWeight(.regular)
                                        
                                        Text("\(item.title)")
                                            .foregroundColor(Color("DarkStaleBlue"))
                                            .font(.headline)
                                        
                                        HStack {
                                            Text("\(item.time) :")
                                                .font(.system(size: 8))
                                                .fontWeight(.light)
                                                .foregroundColor(Color("DarkStaleBlue"))
                                            Text("Rekening Tujuan :")
                                                .foregroundColor(Color("DarkStaleBlue"))
                                                .font(.system(size: 8))
                                                .fontWeight(.ultraLight)
                                            Text("\(item.destinationAccount)")
                                                .foregroundColor(Color("DarkStaleBlue"))
                                                .font(.system(size: 8))
                                                .fontWeight(.light)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
//                .listStyle(GroupedListStyle())
                .colorMultiply(Color(hex: "#F6F8FB"))
            }
        }
    }
}

struct ListHeader: View {
    var title: String
    init(title: String) {
        self.title = title
    }
    var body: some View {
        HStack {
            Text(self.title)
                .foregroundColor(Color(hex: "#232175"))
                .font(.caption2)
        }
    }
}

struct ListNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ListNotificationView()
    }
}
