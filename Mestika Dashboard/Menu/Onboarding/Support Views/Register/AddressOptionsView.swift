//
//  AddressOptionsView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 20/11/20.
//

import SwiftUI

struct AddressOptionsView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Alamat Sesuai KTP"),
        MasterModel(id: 3, name: "Alamat Surat Menyurat"),
        MasterModel(id: 4, name: "Alamat Perusahaan"),
        MasterModel(id: 5, name: "Alamat Lainnya"),
    ]
    
    var body: some View {
        VStack {
            Text("Alamat Pengiriman")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Bold", size: 14))
                .foregroundColor(Color("DarkStaleBlue"))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            RadioButtonGroup(
                items: addressOptions,
                selectedId: $registerData.addressOptionId) { selected in
                
                if let i = addressOptions.firstIndex(where: { $0.id == selected }) {
                    print(addressOptions[i])
                    registerData.addressOptionName = addressOptions[i].name
                }
                
                print("Selected is: \(registerData.addressOptionName)")
                
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width - 100)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
    }
}

struct AddressOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddressOptionsView().environmentObject(RegistrasiModel())
    }
}
