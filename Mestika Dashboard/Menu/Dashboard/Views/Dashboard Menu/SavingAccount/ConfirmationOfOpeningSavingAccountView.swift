//
//  ConfirmationOfOpeningSavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/03/21.
//

import SwiftUI

struct ConfirmationOfOpeningSavingAccountView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    let mySavingProducts:[String] = ["Tabunganku", "Tabungan Mestika"]
    
    @State var product: String = ""
    @State var depositBalance: String = "500.000"
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    VStack {
                        
                        HStack {
                            Text("Produk tabungan")
                            Spacer()
                        }
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        HStack {
                            
                            TextField(NSLocalizedString("Choose a savings product".localized(language), comment: ""), text: $product)
                                .onChange(of: product, perform: { value in
                                })
                                .font(.custom("Montserrat-Bold", size: 12))
                                .padding(.leading, 15)
                                .disabled(true)
                            
                            Menu {
                                ForEach(0..<mySavingProducts.count, id: \.self) { i in
                                    Button(action: {
                                        product = mySavingProducts[i]
                                    }) {
                                        Text(mySavingProducts[i])
                                            .font(.custom("Montserrat-Regular", size: 12))
                                    }
                                }
                            } label: {
                                Image(systemName: "chevron.right").padding()
                            }
                            
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.vertical, 5)
                        
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 5)
                    
                    VStack {
                        
                        HStack {
                            Text("Jumlah Setoran (Rp)")
                            Spacer()
                        }
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        VStack {
                            
                            HStack(alignment: .top, spacing: 0) {
                                Text("Rp.")
                                    .font(.custom("Montserrat-Bold", size: 24))
                                TextField("0", text: $depositBalance)
                                    .font(.custom("Montserrat-Bold", size: 34))
                                Spacer()
                            }
                            .foregroundColor(Color("DarkStaleBlue"))
                            
                            HStack {
                                Text("Setoran Melebihi Saldo Aktif")
                                    .font(.custom("Montserrat-Bold", size: 10))
                                Spacer()
                            }
                            .foregroundColor(.red)
                            
                            Divider()
                            
                            HStack {
                                Text("Total Saldo Aktif")
                                    .font(.custom("Montserrat-Bold", size: 10))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 10))
                                    Text("20000".thousandSeparator())
                                        .font(.custom("Montserrat-Bold", size: 14))
                                }
                                .foregroundColor(Color("StaleBlue"))
                            }
                        }
                    }
                    .padding(25) // padding content
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                    
                    SavingAccountDetailRow(label: "Minimum Setoran Awal", value: "250000")
                    
                    SavingAccountDetailRow(label: "Minimum Setoran Selanjutnya", value: "5000")
                    
                    SavingAccountDetailRow(label: "Minimum Saldo", value: "100000")
                    
                    SavingAccountDetailRow(label: "Biaya Administratif / Bulan", value: "100000")
                }
                .padding(.vertical, 30)
                
            }
            
            VStack {
                Spacer()
                VStack {
                    NavigationLink(destination: ConfirmationOfTransactionSavingAccountView(), label: {
                        Text("KONFIRMASI PEMBUKAAN")
                            .padding()
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(Color("StaleBlue"))
                            .cornerRadius(15)
                    })
                    .padding(.horizontal, 25)
                }
                .frame(maxWidth: .infinity, maxHeight: 65)
                .background(Color.white)
                .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10, x: 2, y: 0)
            }
        }
        .navigationBarTitle("Saving Account")

        
    }
    
    func SavingAccountDetailRow(label: String, value: String) -> some View {
        HStack{
            Text(label)
                .font(.custom("Montserrat-Bold", size: 12))
            
            Spacer()
            
            HStack(alignment: .top, spacing: 0) {
                Text("Rp.")
                    .font(.custom("Montserrat-Bold", size: 10))
                Text(value.thousandSeparator())
                    .font(.custom("Montserrat-Bold", size: 12))
            }
            .foregroundColor(Color("StaleBlue"))
        }
        .padding(.horizontal, 25) // padding content
        .padding(.vertical, 15) // padding content
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10)
        .padding(.horizontal, 25)
    }
}

struct ConfirmationOfOpeningSavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationOfOpeningSavingAccountView()
    }
}
