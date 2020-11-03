//
//  HistoryTransfer.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 02/11/20.
//

import Foundation

struct HistoryTransfer: Identifiable {
    var id: Int
    var tanggalTransaksi, jenisTransaksi, nilaiTransaksi: String
    var username, namaBank, norek: String
}
