//
//  FormChangeAddressView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 05/02/21.
//

import SwiftUI

struct FormChangeAddressView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var profileVM = ProfileViewModel()
    
    var body: some View {
        VStack {
            AppBarLogo(light: true, showBackgroundBlueOnStatusBar: true) {
                
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Text("Address Data")
                        .font(.custom("Montserrat-Bold", size: 22))
                        .foregroundColor(Color(hex: "#232175"))
                    
                    FormAddress
                        .padding(.top, 20)
                    
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
                .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                .padding(25)
                //            .padding(.top, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{profileVM.getProfile(completion: {result in})}
    }
    
    var FormAddress: some View {
        VStack {
            LabelTextField(value: self.$profileVM.alamat, label: "Address", placeHolder: "Address", disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            HStack(spacing: 20) {
                LabelTextField(value: self.$profileVM.rt, label: "RT", placeHolder: "RT", disabled: true, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
                
                LabelTextField(value: self.$profileVM.rw, label: "RW", placeHolder: "RW", disabled: true, onEditingChanged: { (Bool) in
                    print("on edit")
                }, onCommit: {
                    print("on commit")
                })
            }
            
            LabelTextField(value: self.$profileVM.kelurahanName, label: "Sub-District", placeHolder: "Sub-District", disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.kecamatanName, label: "District", placeHolder: "District", disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.kabupatenName, label: "City", placeHolder: "City", disabled: true, onEditingChanged: { (Bool) in
                print("on edit")
            }, onCommit: {
                print("on commit")
            })
            
            LabelTextField(value: self.$profileVM.provinsiName, label: "Province", placeHolder: "Province", disabled: true, onEditingChanged: { (Bool) in
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
