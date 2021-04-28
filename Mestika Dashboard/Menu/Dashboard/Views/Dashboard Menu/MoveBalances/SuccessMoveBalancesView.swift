//
//  SuccessMoveBalancesView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI

struct SuccessMoveBalancesView: View {
    
    // Environtment Object
    @EnvironmentObject var transactionData: MoveBalancesModel
    @EnvironmentObject var appState: AppState
    
    // App Storage
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @State private var uiImage: UIImage = UIImage()
    @State private var sheet = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Image("logo_m_mestika")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .padding(.top, 30)
                    .padding()
                
                VStack(spacing: 5) {
                    Text("\(self.transactionData.trxDateResp)")
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    Text("Pindah Saldo Berhasil")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .padding(.bottom, 30)
                    
                    Text("Nominal".localized(language))
                        .font(.custom("Montserrat-Bold", size: 10))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("Rp.")
                            .font(.custom("Montserrat-Bold", size: 22))
                        Text("\(self.transactionData.amount.thousandSeparator())")
                            .font(.custom("Montserrat-Bold", size: 36))
                    }
                }
                .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Rekening Asal".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.transactionData.sourceAccountName)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(25)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Rekening Tujuan".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.transactionData.destinationName)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(25)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Catatan".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.transactionData.notes)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(25)
                
                Spacer()
                
                Button(
                    action: {
                        self.appState.moveToDashboard = true
                    },
                    label: {
                        Text("Back to Main Page".localized(language))
                            .foregroundColor(Color(hex: "#2334D0"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                

                Spacer()
                
                
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: HStack(spacing: 30) {
            Button(action: {
                self.uiImage = self.asUIImage()
                shareImage()
            }, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
            })
        })
    }
    
    func shareImage() {
        sheet.toggle()
        let av = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SuccessMoveBalancesView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessMoveBalancesView().environmentObject(MoveBalancesModel())
    }
}