//
//  SourceOfFundView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 28/04/21.
//

import SwiftUI

struct SourceOfFundView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    var productATMData = AddProductATM()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
        HStack {
            Text("Funder Information".localized(language))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
            
            Divider()
                .frame(height: 30)
            
            NavigationLink(destination: FormSumberPenyandandDana2View(editMode: .active).environmentObject(registerData)) {
                Text("Edit").foregroundColor(.blue)
            }
        }
        .frame(height: 20)
        .font(.subheadline)
        .padding()
        .cornerRadius(15)
        
        Group {
            Text("Name of Funder".localized(language))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            HStack {
                TextField("Name of Funder".localized(language), text: $registerData.namaPenyandangDana)
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
            Text("Relationship With You".localized(language))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            HStack {
                TextField("Relationship With You".localized(language), text: $registerData.hubunganPenyandangDana)
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
            Text("Profession Funders".localized(language))
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            HStack {
                TextField("Profession Funders".localized(language), text: $registerData.profesiPenyandangDana)
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
    .padding(.bottom, 5)

    }
}

struct SourceOfFundView_Previews: PreviewProvider {
    static var previews: some View {
        SourceOfFundView()
    }
}
