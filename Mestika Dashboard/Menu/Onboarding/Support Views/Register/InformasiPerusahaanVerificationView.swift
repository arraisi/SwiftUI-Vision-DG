//
//  InformasiPerusahaanVerificationView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 10/12/20.
//

import SwiftUI

struct InformasiPerusahaanVerificationView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Informasi Perusahaan")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: InformasiPerusahaanView(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text("Nama Perusahaan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama Perusahaan", text: $registerData.namaPerusahaan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Bidang Usaha")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Bidang Usaha", text: $registerData.bidangUsaha)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Alamat Perusahaan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Alamat Perusahaan", text: $registerData.alamatPerusahaan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kode Pos")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kode Pos", text: $registerData.kodePos)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kecamatan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kecamatan", text: $registerData.kecamatan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kelurahan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kelurahan", text: $registerData.kelurahan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Nomor Telepon")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nomor Telepon", text: $registerData.noTeleponPerusahaan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
        }
    }
}

struct InformasiPerusahaanVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiPerusahaanVerificationView()
    }
}
