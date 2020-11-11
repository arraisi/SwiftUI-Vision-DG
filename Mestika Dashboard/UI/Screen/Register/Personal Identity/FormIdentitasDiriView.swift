//
//  FormIdentitasDiriView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 11/11/20.
//

import SwiftUI

struct FormIdentitasDiriView: View {
    
    @State private var formKtpShow: Bool = true
    @State private var formIndex = 0
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        DisclosureGroup("Foto KTP dan No. Induk Penduduk", isExpanded: $formKtpShow) {
                            
                            ScanKTPView(formIndex: 1) { (nextFormIndex) in
                                print("next index : \(nextFormIndex)")
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 25)
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    .padding([.horizontal, .top], 30)
                    
                    //                    VStack {
                    //                        DisclosureGroup("Foto KTP dan No. Induk Penduduk", isExpanded: $formKtpShow) {
                    //                            ScanKTPView(formIndex: formIndex) { (nextFormIndex) in
                    //                                print(nextFormIndex)
                    //                            }
                    //                        }
                    //                        .padding(.vertical)
                    //                        .padding(.horizontal, 25)
                    //                    }
                    //                    .background(Color.white)
                    //                    .cornerRadius(15)
                    //                    .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0.0, y: 15.0)
                    //                    .padding([.horizontal, .top], 30)
                }
            }
            .background(Color(hex: "#F6F8FB").edgesIgnoringSafeArea(.all))
            .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        }
    }
    
    func formIndex(current: Int, next: Int) -> Int {
        
        print("callback ktp")
        return 1
    }
}

struct FormIdentitasDiriView_Previews: PreviewProvider {
    static var previews: some View {
        FormIdentitasDiriView()
    }
}
