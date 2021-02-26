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
                Text(NSLocalizedString("Company Information".localized(language), comment: ""))
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
                Text(NSLocalizedString("Company name".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Company name".localized(language), comment: ""), text: $registerData.namaPerusahaan)
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
                Text(NSLocalizedString("Business fields".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Business fields".localized(language), comment: ""), text: $registerData.bidangUsaha)
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
                Text(NSLocalizedString("Company's address".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Company's address".localized(language), comment: ""), text: $registerData.alamatPerusahaan)
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
                Text(NSLocalizedString("Postal code".localized(language), comment: ""))
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
                Text(NSLocalizedString("Sub-district".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Sub-district".localized(language), comment: ""), text: $registerData.kecamatan)
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
                Text(NSLocalizedString("Village".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Village".localized(language), comment: ""), text: $registerData.kelurahan)
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
                Text(NSLocalizedString("Phone number".localized(language), comment: ""))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField(NSLocalizedString("Phone number".localized(language), comment: ""), text: $registerData.noTeleponPerusahaan)
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
