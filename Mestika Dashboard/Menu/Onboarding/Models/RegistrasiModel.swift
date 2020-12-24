//
//  RegistrasiModel.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 06/10/20.
//
import Combine
import SwiftUI

class RegistrasiModel: ObservableObject {
    @Published var homeRoute: Bool = false
    @Published var noTelepon = ""
    @Published var jenisTabungan = ""
    @Published var nik = ""
    @Published var email = ""
    @Published var tujuanPembukaanId: Int = 0
    @Published var tujuanPembukaan = ""
    @Published var sumberDanaId: Int = 0
    @Published var sumberDana = ""
    @Published var perkiraanPenarikanId: Int = 0
    @Published var perkiraanPenarikan = ""
    @Published var besarPerkiraanPenarikanId: Int = 0
    @Published var besarPerkiraanPenarikan = ""
    @Published var perkiraanSetoranId: Int = 0
    @Published var perkiraanSetoran = ""
    @Published var pekerjaanId: Int = 0
    @Published var pekerjaan = ""
    @Published var besarPerkiraanSetoranId: Int = 0
    @Published var besarPerkiraanSetoran = ""
    @Published var jabatanProfesiId: Int = 0
    @Published var jabatanProfesi = ""
    @Published var namaPenyandangDana = ""
    @Published var hubunganPenyandangDana:String = ""
    @Published var profesiPenyandangDana:String = ""
    @Published var industriTempatBekerjaId: Int = 0
    @Published var industriTempatBekerja = ""
    @Published var sumberPenyandangDanaId: Int = 0
    @Published var sumberPenyandangDana = ""
    @Published var sumberPendapatanLainnyaId: Int = 0
    @Published var sumberPendapatanLainnya = ""
    @Published var hasSumberPendapatanLainnya: Bool = false
    @Published var sumberPendapatanLain:String? = ""
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
    @Published var penghasilanKotorId: Int = 0
    @Published var penghasilanKotor = ""
    @Published var namaKeluarga: String = ""
    @Published var hubunganKekerabatanKeluarga : String = ""
    @Published var hubunganKekerabatan : String? = ""
    @Published var password = ""
    @Published var pin = ""
    @Published var verificationAddressId: Int = 1
    @Published var confirmationPin = ""
    @Published var fotoKTP: Image = Image("")
    @Published var fotoSelfie: Image = Image("")
    @Published var fotoTandaTangan: Image = Image("")
    @Published var fotoNPWP: Image = Image("")
    @Published var npwp = ""
    @Published var hasNoNpwp: Bool = false
    @Published var namaLengkapFromNik: String = ""
    @Published var nomorKKFromNik: String = ""
    @Published var jenisKelaminFromNik: String = ""
    @Published var tempatLahirFromNik: String = ""
    @Published var tanggalLahirFromNik: String = ""
    @Published var agamaFromNik: String = ""
    @Published var statusPerkawinanFromNik: String = ""
    @Published var pendidikanFromNik: String = ""
    @Published var jenisPekerjaanFromNik: String = ""
    @Published var namaIbuFromNik: String = ""
    @Published var statusHubunganFromNik: String = ""
    @Published var alamatKtpFromNik: String = ""
    @Published var rtFromNik: String = ""
    @Published var rwFromNik: String = ""
    @Published var kelurahanFromNik: String = ""
    @Published var kecamatanFromNik: String = ""
    @Published var kabupatenKotaFromNik: String = ""
    @Published var provinsiFromNik: String = ""
    @Published var bidangUsaha: String = ""
    @Published var desainKartuATMImage: URL = URL(fileURLWithPath: "")
    @Published var noRekening: String = ""
    @Published var noAtm: String = ""
    @Published var atmOrRekening: String = ""
    @Published var isWni: Bool = false
    @Published var isAgree: Bool = false
    @Published var isShareData: Bool = false
    @Published var isAddressEqualToDukcapil: String = ""
    @Published var addressInput: String = ""
    @Published var addressRtRwInput: String = ""
    @Published var addressKelurahanInput: String = ""
    @Published var addressKecamatanInput: String = ""
    @Published var addressPostalCodeInput: String = ""
    
    // For nasabah use only
    @Published var isNasabahmestika: Bool = false
    @Published var accType: String = ""
    @Published var accNo: String = ""
    
    static let shared = RegistrasiModel()
    
    // MARK : Convert to codeable object.
    func convertCodeable() -> RegistrasiModelCodeable {
        return RegistrasiModelCodeable(noTelepon: noTelepon, jenisTabungan: jenisTabungan, nik: nik, email: email, tujuanPembukaanId: tujuanPembukaanId, tujuanPembukaan: tujuanPembukaan, sumberDanaId: sumberDanaId, sumberDana: sumberDana, perkiraanPenarikanId: perkiraanPenarikanId, perkiraanPenarikan: perkiraanPenarikan, besarPerkiraanPenarikanId: besarPerkiraanPenarikanId, besarPerkiraanPenarikan: besarPerkiraanPenarikan, perkiraanSetoranId: perkiraanSetoranId, perkiraanSetoran: perkiraanSetoran, pekerjaanId: pekerjaanId, pekerjaan: pekerjaan, besarPerkiraanSetoranId: besarPerkiraanSetoranId, besarPerkiraanSetoran: besarPerkiraanSetoran, jabatanProfesiId: jabatanProfesiId, jabatanProfesi: jabatanProfesi, namaPenyandangDana: namaPenyandangDana, hubunganPenyandangDana: hubunganPenyandangDana, profesiPenyandangDana: profesiPenyandangDana, industriTempatBekerjaId: industriTempatBekerjaId, industriTempatBekerja: industriTempatBekerja, sumberPenyandangDanaId: sumberPenyandangDanaId, sumberPenyandangDana: sumberPenyandangDana, sumberPendapatanLainnyaId: sumberPendapatanLainnyaId, sumberPendapatanLainnya: sumberPendapatanLainnya, sumberPendapatanLain: sumberPendapatanLain, namaPerusahaan: namaPerusahaan, alamatPerusahaan: alamatPerusahaan, alamatKeluarga: alamatKeluarga, kodePosKeluarga: kodePosKeluarga, kecamatanKeluarga: kecamatanKeluarga, kelurahanKeluarga: kelurahanKeluarga, noTlpKeluarga: noTlpKeluarga, kodePos: kodePos, kecamatan: kecamatan, kelurahan: kelurahan, rtrw: rtrw, noTeleponPerusahaan: noTeleponPerusahaan, penghasilanKotorId: penghasilanKotorId, penghasilanKotor: penghasilanKotor, namaKeluarga: namaKeluarga, hubunganKekerabatan: hubunganKekerabatan, password: password, pin: pin, verificationAddressId: verificationAddressId, confirmationPin: confirmationPin, fotoKTP: fotoKTP.toBase64(), fotoSelfie: fotoSelfie.toBase64(), fotoTandaTangan: fotoTandaTangan.toBase64(), fotoNPWP: fotoNPWP.toBase64(), npwp: npwp, hasNoNpwp: hasNoNpwp, namaLengkapFromNik: namaLengkapFromNik, nomorKKFromNik: nomorKKFromNik, jenisKelaminFromNik: jenisKelaminFromNik, tempatLahirFromNik: tempatLahirFromNik, tanggalLahirFromNik: tanggalLahirFromNik, agamaFromNik: agamaFromNik, statusPerkawinanFromNik: statusPerkawinanFromNik, pendidikanFromNik: pendidikanFromNik, jenisPekerjaanFromNik: jenisTabungan, namaIbuFromNik: namaIbuFromNik, statusHubunganFromNik: statusHubunganFromNik, alamatKtpFromNik: alamatKtpFromNik, rtFromNik: rtFromNik, rwFromNik: rwFromNik, kelurahanFromNik: kelurahanFromNik, kecamatanFromNik: kecamatanFromNik, kabupatenKotaFromNik: kabupatenKotaFromNik, provinsiFromNik: provinsiFromNik, bidangUsaha: bidangUsaha)
    }
    
    func convertToObserveable(codeableObject: RegistrasiModelCodeable) {
        noTelepon = codeableObject.noTelepon
        self.jenisTabungan = codeableObject.jenisTabungan
        self.nik = codeableObject.nik
        self.email = codeableObject.email
        self.tujuanPembukaanId = codeableObject.tujuanPembukaanId
        self.tujuanPembukaan = codeableObject.tujuanPembukaan
        self.sumberDanaId = codeableObject.sumberDanaId
        self.sumberDana = codeableObject.sumberDana
        self.perkiraanPenarikanId = codeableObject.perkiraanPenarikanId
        self.perkiraanPenarikan = codeableObject.perkiraanPenarikan
        self.besarPerkiraanPenarikanId = codeableObject.besarPerkiraanPenarikanId
        self.besarPerkiraanPenarikan = codeableObject.besarPerkiraanPenarikan
        self.perkiraanSetoranId = codeableObject.perkiraanSetoranId
        self.perkiraanSetoran = codeableObject.perkiraanSetoran
        self.pekerjaanId = codeableObject.pekerjaanId
        self.pekerjaan = codeableObject.pekerjaan
        self.besarPerkiraanSetoranId = codeableObject.besarPerkiraanSetoranId
        self.besarPerkiraanSetoran = codeableObject.besarPerkiraanSetoran
        self.jabatanProfesiId = codeableObject.jabatanProfesiId
        self.jabatanProfesi = codeableObject.jabatanProfesi
        self.namaPenyandangDana = codeableObject.namaPenyandangDana
        self.hubunganPenyandangDana = codeableObject.hubunganPenyandangDana
        self.profesiPenyandangDana = codeableObject.profesiPenyandangDana
        self.industriTempatBekerjaId = codeableObject.industriTempatBekerjaId
        self.industriTempatBekerja = codeableObject.industriTempatBekerja
        self.sumberPenyandangDanaId = codeableObject.sumberPenyandangDanaId
        self.sumberPenyandangDana = codeableObject.sumberPenyandangDana
        self.sumberPendapatanLainnyaId = codeableObject.sumberPendapatanLainnyaId
        self.sumberPendapatanLainnya = codeableObject.sumberPendapatanLainnya
        self.sumberPendapatanLain = codeableObject.sumberPendapatanLain
        self.namaPerusahaan = codeableObject.namaPerusahaan
        self.alamatPerusahaan = codeableObject.alamatPerusahaan
        self.alamatKeluarga = codeableObject.alamatKeluarga
        self.kodePosKeluarga = codeableObject.kodePosKeluarga
        self.kecamatanKeluarga = codeableObject.kecamatanKeluarga
        self.kelurahanKeluarga = codeableObject.kelurahanKeluarga
        self.noTlpKeluarga = codeableObject.noTlpKeluarga
        self.kodePos = codeableObject.kodePos
        self.kecamatan = codeableObject.kecamatan
        self.kelurahan = codeableObject.kelurahan
        self.rtrw = codeableObject.rtrw
        self.noTeleponPerusahaan = codeableObject.noTeleponPerusahaan
        self.penghasilanKotorId = codeableObject.penghasilanKotorId
        self.penghasilanKotor = codeableObject.penghasilanKotor
        self.namaKeluarga = codeableObject.namaKeluarga
        self.hubunganKekerabatan = codeableObject.hubunganKekerabatan
        self.password = codeableObject.password
        self.pin = codeableObject.pin
        self.verificationAddressId = codeableObject.verificationAddressId
        self.confirmationPin = codeableObject.confirmationPin
        self.fotoKTP = Image(uiImage: codeableObject.fotoKTP?.base64ToImage() ?? UIImage())
        self.fotoSelfie = Image(uiImage: codeableObject.fotoSelfie?.base64ToImage() ?? UIImage())
        self.fotoTandaTangan = Image(uiImage: codeableObject.fotoTandaTangan?.base64ToImage() ?? UIImage())
        self.fotoNPWP = Image(uiImage: codeableObject.fotoNPWP?.base64ToImage() ?? UIImage())
        self.npwp = codeableObject.npwp
        self.hasNoNpwp = codeableObject.hasNoNpwp
        self.namaLengkapFromNik = codeableObject.namaLengkapFromNik
        self.nomorKKFromNik = codeableObject.nomorKKFromNik
        self.jenisKelaminFromNik = codeableObject.jenisKelaminFromNik
        self.tempatLahirFromNik = codeableObject.tempatLahirFromNik
        self.tanggalLahirFromNik = codeableObject.tanggalLahirFromNik
        self.agamaFromNik = codeableObject.agamaFromNik
        self.statusPerkawinanFromNik = codeableObject.statusPerkawinanFromNik
        self.pendidikanFromNik = codeableObject.pendidikanFromNik
        self.jenisPekerjaanFromNik = codeableObject.jenisTabungan
        self.namaIbuFromNik = codeableObject.namaIbuFromNik
        self.statusHubunganFromNik = codeableObject.statusHubunganFromNik
        self.alamatKtpFromNik = codeableObject.alamatKtpFromNik
        self.rtFromNik = codeableObject.rtFromNik
        self.rwFromNik = codeableObject.rwFromNik
        self.kelurahanFromNik = codeableObject.kelurahanFromNik
        self.kecamatanFromNik = codeableObject.kecamatanFromNik
        self.kabupatenKotaFromNik = codeableObject.kabupatenKotaFromNik
        self.provinsiFromNik = codeableObject.provinsiFromNik
        self.bidangUsaha = codeableObject.bidangUsaha
    }
    
    // MARK : save to local
    func save() {
        let codeableObject = convertCodeable()
        let userDefaults = UserDefaults.standard
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(codeableObject)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            userDefaults.set(json, forKey: "registerModel")
            print("Saved to user defaults")
        } catch {
            print("Gagal Encode")
        }
    }
    
    func load() {
         let userDefaults = UserDefaults.standard
        do {
            if let json = userDefaults.string(forKey: "registerModel") {
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(RegistrasiModelCodeable.self, from: Data(json.utf8))
                convertToObserveable(codeableObject: result)
            }
        } catch {
            print("Gagal decode")
        }
    }
    
    func clear() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "registerModel")
    }
    
}

// MARK : Codeable Model
struct RegistrasiModelCodeable: Codable {
    var noTelepon : String = ""
    var jenisTabungan: String = ""
    var nik: String = ""
    var email: String = ""
    var tujuanPembukaanId: Int = 0
    var tujuanPembukaan: String = ""
    var sumberDanaId: Int = 0
    var sumberDana: String = ""
    var perkiraanPenarikanId: Int = 0
    var perkiraanPenarikan: String = ""
    var besarPerkiraanPenarikanId: Int = 0
    var besarPerkiraanPenarikan: String = ""
    var perkiraanSetoranId: Int = 0
    var perkiraanSetoran: String = ""
    var pekerjaanId: Int = 0
    var pekerjaan: String = ""
    var besarPerkiraanSetoranId: Int = 0
    var besarPerkiraanSetoran: String = ""
    var jabatanProfesiId: Int = 0
    var jabatanProfesi: String = ""
    var namaPenyandangDana: String = ""
    var hubunganPenyandangDana:String = ""
    var profesiPenyandangDana:String = ""
    var industriTempatBekerjaId: Int = 0
    var industriTempatBekerja: String = ""
    var sumberPenyandangDanaId: Int = 0
    var sumberPenyandangDana: String = ""
    var sumberPendapatanLainnyaId: Int = 0
    var sumberPendapatanLainnya: String = ""
    var sumberPendapatanLain:String? = ""
    var namaPerusahaan: String = ""
    var alamatPerusahaan: String = ""
    var alamatKeluarga: String = ""
    var kodePosKeluarga: String = ""
    var kecamatanKeluarga: String = ""
    var kelurahanKeluarga: String = ""
    var noTlpKeluarga: String = ""
    var kodePos: String = ""
    var kecamatan: String = ""
    var kelurahan: String = ""
    var rtrw: String = ""
    var noTeleponPerusahaan: String = ""
    var penghasilanKotorId: Int = 0
    var penghasilanKotor: String = ""
    var namaKeluarga: String = ""
    var hubunganKekerabatan : String? = ""
    var password: String = ""
    var pin: String = ""
    var verificationAddressId = 1
    var confirmationPin: String = ""
    var fotoKTP: String? = ""
    var fotoSelfie: String? = ""
    var fotoTandaTangan: String? = ""
    var fotoNPWP: String? = ""
    var npwp: String = ""
    var hasNoNpwp: Bool = false
    var namaLengkapFromNik: String = ""
    var nomorKKFromNik: String = ""
    var jenisKelaminFromNik: String = ""
    var tempatLahirFromNik: String = ""
    var tanggalLahirFromNik: String = ""
    var agamaFromNik: String = ""
    var statusPerkawinanFromNik: String = ""
    var pendidikanFromNik: String = ""
    var jenisPekerjaanFromNik: String = ""
    var namaIbuFromNik: String = ""
    var statusHubunganFromNik: String = ""
    var alamatKtpFromNik: String = ""
    var rtFromNik: String = ""
    var rwFromNik: String = ""
    var kelurahanFromNik: String = ""
    var kecamatanFromNik: String = ""
    var kabupatenKotaFromNik: String = ""
    var provinsiFromNik: String = ""
    var bidangUsaha: String = ""
}
