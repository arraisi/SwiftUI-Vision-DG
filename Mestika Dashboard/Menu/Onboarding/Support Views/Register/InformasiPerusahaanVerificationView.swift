//
//  InformasiPerusahaanVerificationView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 10/12/20.
//

import SwiftUI

struct InformasiPerusahaanVerificationView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Company Information".localized(language))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: InformasiPerusahaanView(editMode: .active, isEditFromSummary: true).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .padding(.top, 5)
            .cornerRadius(15)
            
            Group {
                Text("Company name".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Company name".localized(language), text: $registerData.namaPerusahaan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            if (registerData.pekerjaanId == 3 || registerData.pekerjaanId == 9) {
                Group {
                    Text("Business fields".localized(language))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    HStack {
                        TextField("Business fields".localized(language), text: $registerData.bidangUsaha)
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
            
            Group {
                Text("Company's address".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                
                HStack {
                    MultilineTextField("Company's address".localized(language), text: $registerData.alamatPerusahaan, onCommit: {
                    })
                    .font(Font.system(size: 14))
                    .disabled(true)
                }
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Postal code".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Postal code".localized(language), text: $registerData.kodePos)
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
                Text("Sub-district".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Sub-district".localized(language), text: $registerData.kecamatan)
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
                Text("Village".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Village".localized(language), text: $registerData.kelurahan)
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
                Text("City".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("City".localized(language), text: $registerData.kotaPerusahaan)
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
                Text("Province".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Province".localized(language), text: $registerData.provinsiPerusahaan)
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
                Text("Phone number".localized(language))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Phone number".localized(language), text: $registerData.noTeleponPerusahaan)
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
