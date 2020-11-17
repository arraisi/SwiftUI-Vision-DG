//
//  RegistrasiModel.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 06/10/20.
//
import Combine
import SwiftUI

class RegistrasiModel: ObservableObject {
    @Published var noTelepon = ""
    @Published var jenisTabungan = ""
    @Published var nik = ""
    @Published var email = ""
    @Published var tujuanPembukaanId: Int = 0
    @Published var tujuanPembukaan = ""
    @Published var sumberDanaId = 0
    @Published var sumberDana = ""
    @Published var perkiraanPenarikanId = 0
    @Published var perkiraanPenarikan = ""
    @Published var besarPerkiraanPenarikanId = 0
    @Published var besarPerkiraanPenarikan = ""
    @Published var perkiraanSetoranId = 0
    @Published var perkiraanSetoran = ""
    @Published var pekerjaanId = 0
    @Published var pekerjaan = ""
    @Published var besarPerkiraanSetoranId = 0
    @Published var besarPerkiraanSetoran = ""
    @Published var sumberPenyandangDanaId = 0
    @Published var sumberPenyandangDana = ""
    @Published var sumberPendapatanLainnyaId = 0
    @Published var sumberPendapatanLainnya = ""
    @Published var namaPerusahaan = ""
    @Published var alamatPerusahaan = ""
    @Published var alamatKeluarga = ""
    @Published var kodePosKeluarga = ""
    @Published var kecamatanKeluarga = ""
    @Published var kelurahanKeluarga = ""
    @Published var noTlpKeluarga = ""
    @Published var kodePos = ""
    @Published var kecamatan = ""
    @Published var kelurahan = ""
    @Published var rtrw = ""
    @Published var noTeleponPerusahaan = ""
    @Published var penghasilanKotorId = 0
    @Published var penghasilanKotor = ""
    @Published var namaKeluarga: String = ""
    @Published var hubunganKekerabatan : String? = ""
    @Published var password = ""
    @Published var pin = ""
    @Published var verificationAddressId = 1
    @Published var confirmationPin = ""
    @Published var fotoKTP: Image = Image("")
    @Published var fotoSelfie: Image = Image("")
    @Published var fotoTandaTangan: Image = Image("")
    @Published var fotoNPWP: Image = Image("")
    @Published var npwp = ""
    @Published var hasNoNpwp: Bool = false
}
