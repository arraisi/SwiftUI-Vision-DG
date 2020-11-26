//
//  FormCompletionReferalCodeView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI
import NavigationStack

struct FormCompletionReferalCodeView: View {
    /* Environtment Object */
    @EnvironmentObject var atmData: AddProductATM
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var productVM = ATMProductViewModel()
    
    @State private var goToSuccessPage = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("bg_blue")
                    .resizable()
                    .scaledToFill()
            }
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
                ScrollView {
                    Text("LENGKAPI DATA")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    
                    referalCodeCard
                    
                    NavigationLink(destination: FormDetailKartuATMView().environmentObject(atmData), isActive: $goToSuccessPage){
                        
                    }
                    Button(action: {
                        self.postData()
                    }) {
                        Text(productVM.isLoading ? "Harap Tunggu" : "SUBMIT")
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
                    .disabled(productVM.isLoading)
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
                        
                        TextField("Masukkan kode referal", text: $atmData.atmAddresspostalReferral) { changed in
                            
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
    
    func postData() {
        productVM.addProductATM(dataRequest: atmData) { (success: Bool) in
            if success {
                self.goToSuccessPage = true
            }
        }
    }
}

struct FormCompletionReferalCodeView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionReferalCodeView()
            .environmentObject(AddProductATM())
    }
}
