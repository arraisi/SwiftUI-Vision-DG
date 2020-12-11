//
//  InformasiKeluargaVerificationView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 10/12/20.
//

import SwiftUI

struct InformasiKeluargaVerificationView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Keluarga Terdekat Anda")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: KeluargaTerdekat(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text("Hubungan Dengan Anda")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Hubungan Dengan Anda", text: $registerData.hubunganKekerabatanKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Nama")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama", text: $registerData.namaKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Alamat")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Alamat Perusahaan", text: $registerData.alamatKeluarga)
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
                    TextField("Kode Pos", text: $registerData.kodePosKeluarga)
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
                    TextField("Kecamatan", text: $registerData.kecamatanKeluarga)
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
                    TextField("Kelurahan", text: $registerData.kelurahanKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
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
                    TextField("Nomor Telepon", text: $registerData.noTlpKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
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

struct InformasiKeluargaVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        InformasiKeluargaVerificationView()
    }
}
