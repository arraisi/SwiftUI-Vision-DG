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
                        
                        Text(NSLocalizedString("Template", comment: ""))
                            .font(.title)
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 20)
                            .padding(.trailing, 20)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("Anda telah memilih mendaftar jenis tabungan", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#707070"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 5)
                            .padding(.horizontal, 20)
                        
                        Text(NSLocalizedString("Deposit Tabungan.", comment: ""))
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color(hex: "#2334D0"))
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 20)
                    }
                    
                    Text(NSLocalizedString("Sebelum melanjutkan proses pendaftaran, silahkan terlebih dahulu memverifikasi data yang telah Anda Isi.", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 15)
                        .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    Group {
                        LabelTextField(value: $jenisTabungan, label: NSLocalizedString("Jenis Tabungan", comment: ""), placeHolder: NSLocalizedString("Jenis Tabungan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Tujuan Pembukaan Rekening", comment: ""), placeHolder: NSLocalizedString("Tujuan Pembukaan Rekening", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Sumber Dana", comment: ""), placeHolder: NSLocalizedString("Sumber Dana", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Pekerjaan", comment: ""), placeHolder: NSLocalizedString("Pekerjaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Jabatan", comment: ""), placeHolder: NSLocalizedString("Jabatan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Nama Perusahaan", comment: ""), placeHolder: NSLocalizedString("Nama Perusahaan", comment: "")) { (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Alamat Perusahaan", comment: ""), placeHolder: NSLocalizedString("Alamat Perusahaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Kecamatan Perusahaan", comment: ""), placeHolder: NSLocalizedString("Kecamatan Perusahaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Kelurahan Perusahaan", comment: ""), placeHolder: NSLocalizedString("Kelurahan Perusahaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Kode Pos Perusahaan", comment: ""), placeHolder: NSLocalizedString("Kode Pos Perusahaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    Group {
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("No. Perusahaan", comment: ""), placeHolder: NSLocalizedString("No. Perusahaan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Bidang Usaha", comment: ""), placeHolder: NSLocalizedString("Bidang Usaha", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                        
                        LabelTextField(value: $tujuanPembukaanRekening, label: NSLocalizedString("Penghasilan", comment: ""), placeHolder: NSLocalizedString("Penghasilan", comment: "")){ (Bool) in
                            print("on edit")
                        } onCommit: {
                            print("on commit")
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        NavigationLink(destination : VerificationAddressView()) {
                            Text(NSLocalizedString("Data Valid", comment: ""))
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
                            Text(NSLocalizedString("Data Valid", comment: ""))
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
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct VerificationDataPersonalView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationDataPersonalView().environmentObject(RegistrasiModel())
    }
}
