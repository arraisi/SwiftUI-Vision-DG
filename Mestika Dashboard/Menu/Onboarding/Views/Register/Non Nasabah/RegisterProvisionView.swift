//
//  RegisterProvisionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 24/09/20.
//

import SwiftUI

struct RegisterProvisionView: View {
    
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /* Data Binding */
    @Binding var rootIsActive : Bool
    
    /* Data Model */
    @State var data = [
        ProvisionModel(
            id: 1,
            number: "01.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        ProvisionModel(
            id: 2,
            number: "02.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        ProvisionModel(
            id: 3,
            number: "03.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
        ProvisionModel(
            id: 4,
            number: "04.",
            caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod"
        ),
    ]
    
    // MARK: -MAIN CONTENT
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            cardForm
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
    
    var cardForm: some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            Text("Sebelum Memulai..!!")
                .font(.title2)
                .foregroundColor(Color(hex: "#232175"))
                .fontWeight(.bold)
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            ForEach(data) { data in
                HStack(alignment: .top) {
                    Text(data.number)
                        .font(.caption)
                        .foregroundColor(Color(hex: "#232175"))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(data.caption)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)
            }
            
            NavigationLink(destination: PhoneVerificationView(rootIsActive: self.$rootIsActive).environmentObject(registerData)) {
                Text("Lanjut Membuat Rekening")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
            .padding(.top, 10)
            
            Button(action : {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Batal Mendaftar")
                    .foregroundColor(.gray)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 30)
        .padding(.top, 120)
    }
}

struct RegisterProvisionView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterProvisionView(rootIsActive: .constant(false)).environmentObject(RegistrasiModel())
    }
}

struct ProvisionModel: Identifiable {
    var id: Int
    var number: String
    var caption: String
}
