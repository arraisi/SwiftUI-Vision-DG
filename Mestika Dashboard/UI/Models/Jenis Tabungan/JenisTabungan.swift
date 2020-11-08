//
//  Jenis Tabungan.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 04/10/20.
//

import SwiftUI

struct JenisTabungan: Hashable, Codable, Identifiable {
    var id: Int
    var namaTabungan: String
    var kartu: String
    var show: Bool
}
