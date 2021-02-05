//
//  FormChangeAddressView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI

struct FormChangeAddressView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var address: String = ""
    @State private var rt: String = ""
    @State private var rw: String = ""
    @State private var subDistrict: String = ""
    @State private var district: String = ""
    @State private var city: String = ""
    @State private var province: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Address Data")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(Color(hex: "#2334D0"))
                
                FormAddress
                    .padding(.top, 30)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                }
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.top, 30)
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(25)
            .padding(.top, 30)
        }
        .navigationBarTitle("Address", displayMode: .inline)
        
    }
    
    var FormAddress: some View {
        VStack {
            LabelTextField(value: $address, label: "Address", placeHolder: "Address", onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            HStack(spacing: 20) {
                LabelTextField(value: $rt, label: "RT", placeHolder: "RT", onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: $rw, label: "RW", placeHolder: "RW", onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
            
            LabelTextField(value: $subDistrict, label: "Sub-District", placeHolder: "Sub-District", onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: $district, label: "District", placeHolder: "District", onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: $city, label: "City", placeHolder: "City", onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: $province, label: "Province", placeHolder: "Province", onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
        }
    }
}

struct FormChangeAddressView_Previews: PreviewProvider {
    static var previews: some View {
        FormChangeAddressView()
    }
}
