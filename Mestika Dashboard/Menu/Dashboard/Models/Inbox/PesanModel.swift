//
//  PesanModel.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 22/04/21.
//

import Foundation

struct PesanModel: Hashable {
    var date: String
    var pesan: [PesanItemModel]
}

extension PesanModel {
    static func all() -> [PesanModel] {
        
        return [
            PesanModel(date: "Oktober 2020",
                       pesan: [
                        PesanItemModel(iconName: "folder.circle", status: "Schedule", pesan: "PLN PASCABAYAR", date: "20 Oktober 2020", transaksi: "100000", pengirim: "Admin"),
                        PesanItemModel(iconName: "folder.circle", status: "Gagal", pesan: "NOVI PAHMALIA", date: "20 Oktober 2020", transaksi: "100000", pengirim: "Admin"),
                        PesanItemModel(iconName: "folder.circle", status: "Berhasil", pesan: "Request Money", date: "20 Oktober 2020", transaksi: "100000", pengirim: "Admin")
                       ]),
            PesanModel(date: "November 2020",
                       pesan: [
                        PesanItemModel(iconName: "folder.circle", status: "Berhasil", pesan: "BAMBANG P", date: "20 November 2020", transaksi: "100000", pengirim: "Admin"),
                       ]),
            PesanModel(date: "Desember 2020",
                       pesan: [
                        PesanItemModel(iconName: "folder.circle", status: "Berhasil", pesan: "DARI PLATINUM SERVER", date: "20 Desember 2020", transaksi: "100000", pengirim: "Admin"),
                       ])
        ]
    }
}

struct PesanItemModel: Hashable {
    var iconName: String
    var status: String
    var pesan: String
    var date: String
    var transaksi: String
    var pengirim: String
}
