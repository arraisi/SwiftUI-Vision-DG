//
//  VerificationDataPersonalView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct VerificationDataPersonalView: View {
    
    @State var jenisTabungan: String = ""
    @State var tujuanPembukaanRekening: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Image("ic_highfive")
                        .resizable()
                        .frame(width: 95, height: 95)
                        .padding(.top, 40)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Text("Hi, ")
                            .font(.title)
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.leading, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text("Template")
                            .font(.title)
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.trailing, 20)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Anda telah memilih mendaftar jenis tabungan")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .padding(.horizontal, 20)
                        
                        Text("Deposit Tabungan.")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color(hex: "#2334D0"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    }
                    
                    Text("Sebelum melanjutkan proses pendaftaran, silahkan terlebih dahulu memverifikasi data yang telah Anda Isi.")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    Group {
                        LabelTextField(value: $jenisTabungan, label: "Jenis Tabungan", placeHolder: "Jenis Tabungan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Tujuan Pembukaan Rekening", placeHolder: "Tujuan Pembukaan Rekening"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Sumber Dana", placeHolder: "Sumber Dana"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Pekerjaan", placeHolder: "Pekerjaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Jabatan", placeHolder: "Jabatan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Nama Perusahaan", placeHolder: "Nama Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Alamat Perusahaan", placeHolder: "Alamat Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Kecamatan Perusahaan", placeHolder: "Kecamatan Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Kelurahan Perusahaan", placeHolder: "Kelurahan Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Kode Pos Perusahaan", placeHolder: "Kode Pos Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    Group {
                        LabelTextField(value: $tujuanPembukaanRekening, label: "No. Perusahaan", placeHolder: "No. Perusahaan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Bidang Usaha", placeHolder: "Bidang Usaha"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: "Penghasilan", placeHolder: "Penghasilan"){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination : VerificationAddressView()) {
                            Text("Data Valid")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            
                        }
                        .frame(height: 40)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 5)
                        .padding(.vertical, 20)
                        
                        Button(action : {}) {
                            Text("Tidak Valid")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 40)
                            
                        }
                        .frame(height: 40)
                        .background(Color(hex: "#707070"))
                        .cornerRadius(12)
                        .padding(.trailing, 20)
                        .padding(.leading, 5)
                        .padding(.vertical, 20)
                    }
                    
                    Spacer()
                }
                .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 30)
                .padding(.horizontal, 30)
                .padding(.top, 90)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
    }
}

struct VerificationDataPersonalView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationDataPersonalView().environmentObject(RegistrasiModel())
    }
}
