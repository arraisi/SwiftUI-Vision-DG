//
//  CustomAppBar.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 01/12/20.
//

import SwiftUI

struct CustomAppBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var light: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.2)
                    .foregroundColor(light ? Color("DarkStaleBlue") : Color.white)
                })
                
                logo
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                
                Spacer().frame(width: UIScreen.main.bounds.width * 0.2)
                
            }
            .padding(.vertical)
            //        .padding(.top, 50)
            //        .padding(.bottom, 5).
        }
        .frame(height: 80)
        .background(light ?  Color.white : Color("DarkStaleBlue"))
        
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            if light {
                Image("Logo M")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("BANK MESTIKA")
                    .foregroundColor(Color(hex: "#232175"))
                    .font(.system(size: 20))
                    .bold()
            } else {
                Image("logo_mestika")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
            }
        }
    }
}

struct CustomAppBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppBar(light: false)
    }
}
