//
//  FieldSummaryView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 27/04/21.
//

import SwiftUI

struct FieldSummaryView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @Binding var value: String
    let label: String
    let onEdit: ()->()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(label.localized(language))
                .font(Font.system(size: 12))
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            HStack {
                TextField(label.localized(language), text: $value)
                    .disabled(true)
                
                Divider()
                    .frame(height: 30)
                
                Button(action: {
                    onEdit()
                }) {
                    Text("Edit").foregroundColor(.blue)
                }
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

struct FieldSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        FieldSummaryView(value: .constant(""), label: "") {
            
        }
    }
}
