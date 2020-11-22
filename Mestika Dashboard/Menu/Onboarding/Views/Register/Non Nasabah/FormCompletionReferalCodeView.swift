//
//  FormCompletionReferalCodeView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI

struct FormCompletionReferalCodeView: View {
    /* Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var referalCode: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("bg_blue")
                    .resizable()
                    .scaledToFill()
            }
            VStack {
                appBar
                ScrollView {
                    Text("LENGKAPI DATA")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    
                    referalCodeCard
                    
                    NavigationLink(destination: FormDetailKartuATMView().environmentObject(registerData)) {
                        Text("SUBMIT")
                            .foregroundColor(Color("DarkStaleBlue"))
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                    .padding(.vertical, 30)
                }
            }
        }
        .introspectNavigationController { navigationController in
            navigationController.hidesBarsOnSwipe = true
        }
        .edgesIgnoringSafeArea(.top)
//        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
    }
    
    // MARK: - APP BAR
    var appBar: some View {
        HStack {
            Spacer()
            logo
            Spacer()
        }
        .padding(.top, 60)
    }
    
    // MARK: - LOGO
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("logo_mestika")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 25)
        }
    }
    
    var referalCodeCard: some View {
        ZStack {
            VStack {
                Text("Masukkan Kode Referal")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("Dari mana Anda tahu informasi Digital Banking Bank mestika")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 10))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Group {
                    
                    Text("")
                        .font(Font.system(size: 10))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Masukkan kode referal", text: $referalCode) { changed in
                            
                        } onCommit: {
                        }
                        .font(Font.system(size: 14))
                        .frame(height: 36)
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
}

struct FormCompletionReferalCodeView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionReferalCodeView()
            .environmentObject(RegistrasiModel())
    }
}
