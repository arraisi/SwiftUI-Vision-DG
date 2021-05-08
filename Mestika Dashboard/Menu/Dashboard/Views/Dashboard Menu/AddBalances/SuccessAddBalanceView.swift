//
//  SuccessAddBalanceView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI

struct SuccessAddBalanceView: View {
    
    // Environtment Object
    @EnvironmentObject var transactionData: MoveBalancesModel
    @EnvironmentObject var appState: AppState
    
    // App Storage
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    // Local Variable
    @State private var tglTrx: String = ""
    @State private var sourceName: String = ""
    @State private var destinationName: String = ""
    @State private var notes: String = ""
    @State private var amount: String = ""
    
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
                    .frame(width: 70, height: 70, alignment: .center)
                    .padding()
                
                VStack(spacing: 5) {
                    Text("\(self.tglTrx)")
                        .font(.custom("Montserrat-Bold", size: 12))
                    
                    Text("Tambah Saldo Berhasil")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .padding(.bottom, 30)
                    
                    Text("Nominal".localized(language))
                        .font(.custom("Montserrat-Bold", size: 10))
                    
                    HStack(alignment: .top, spacing: 0) {
                        Text("Rp.")
                            .font(.custom("Montserrat-Bold", size: 22))
                        Text("\(self.amount.thousandSeparator())")
                            .font(.custom("Montserrat-Bold", size: 36))
                    }
                }
                .foregroundColor(.white)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Rekening Asal".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.sourceName)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Rekening Tujuan".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.destinationName)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text("Catatan".localized(language))
                            .font(.custom("Montserrat-Bold", size: 10))
                        
                        Text("\(self.notes)")
                            .font(.custom("Montserrat-Bold", size: 20))
                            .padding(.bottom, 15)
                        
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
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
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.tglTrx = self.transactionData.transactionDate
            self.sourceName = self.transactionData.sourceAccountName
            self.destinationName = self.transactionData.destinationName
            self.notes = self.transactionData.notes
            self.amount = self.transactionData.amount
        }
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

struct SuccessAddBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessAddBalanceView().environmentObject(MoveBalancesModel())
    }
}
