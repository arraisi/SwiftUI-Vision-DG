//
//  CustomNavigationBarView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 29/09/20.
//

import SwiftUI

struct CustomNavigationBarView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        HStack {
            
            Button(action: {
                
                presentationMode.wrappedValue.dismiss()
                
            }) {
                
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                
            }
            
            Spacer()
            
            logo
            
            Spacer()
            
        }
        
    }
    
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("Logo M")
                .resizable()
                .frame(width: 25, height: 25)
            Text("BANK MESTIKA")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .bold()
        }
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBarView()
    }
}
