//
//  AddressOptionsView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 20/11/20.
//

import SwiftUI

struct AddressOptionsView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    let addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Address according to Identity Card/(KTP)".localized(LocalizationService.shared.language)),
        MasterModel(id: 3, name: "Mailing address".localized(LocalizationService.shared.language)),
        MasterModel(id: 4, name: "Company's address".localized(LocalizationService.shared.language)),
//        MasterModel(id: 5, name: "Other Address".localized(LocalizationService.shared.language)),
    ]
    
    @State var addressOptionId: Int = 1
    
    var body: some View {
        VStack {
            Text("Shipping address".localized(language))
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Bold", size: 14))
                .foregroundColor(Color("DarkStaleBlue"))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            RadioButtonGroup(
                items: addressOptions,
                selectedId: $addressOptionId) { selected in
                
                if let i = addressOptions.firstIndex(where: { $0.id == selected }) {
                    print(addressOptions[i])
//                    registerData.addressOptionName = addressOptions[i].name
                }
                
                print("Selected is: \(selected)")
                
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
