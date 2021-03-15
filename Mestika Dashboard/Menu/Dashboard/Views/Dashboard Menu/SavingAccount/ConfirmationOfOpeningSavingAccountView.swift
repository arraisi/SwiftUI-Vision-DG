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
    
    @StateObject var productsSavingAccountVM = ProductsSavingAccountViewModel()
    
    //    let mySavingProducts:[String] = ["Tabunganku", "Tabungan Mestika"]
    
    @Binding var product: String
    
    @State var codePlan: String = ""
    @State var depositBalance: String = "0"
    
    var currency = "0"
    var minimumSaldo = "0"
    var biayaAdministrasi = "0"
    var minimumSetoranAwal = "0"
    
    var nextBtnDisabled: Bool {
        product.count == 0 || depositBalance.count == 0
    }
    
    var body: some View {
        
        ZStack {
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    VStack {
                        
                        HStack {
                            Text("Savings product".localized(language))
                            Spacer()
                        }
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        HStack {
                            
                            TextField("Choose a savings product".localized(language), text: $product)
                                .onChange(of: product, perform: { value in
                                })
                                .font(.custom("Montserrat-Bold", size: 12))
                                .padding(.leading, 15)
                                .disabled(true)
                            
                            Menu {
                                ForEach(0..<productsSavingAccountVM.products.count, id: \.self) { i in
                                    Button(action: {
                                        self.product = productsSavingAccountVM.products[i].name
                                        self.codePlan = productsSavingAccountVM.products[i].codePlan
                                    }) {
                                        Text(productsSavingAccountVM.products[i].name)
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
                            Text("Deposit Amount (Rp)".localized(language))
                            Spacer()
                        }
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        
                        VStack {
                            
                            HStack(alignment: .top, spacing: 0) {
                                Text("Rp.")
                                    .font(.custom("Montserrat-Bold", size: 24))
                                
                                TextField("0", text: $depositBalance)
                                    .font(.custom("Montserrat-Bold", size: 34))
                                    .onReceive(depositBalance.publisher.collect()) {
                                        let amountString = String($0.prefix(13))
                                        let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                        self.depositBalance = cleanAmount.thousandSeparator()
                                    }
                                    .keyboardType(.numberPad)
                                Spacer()
                            }
                            .foregroundColor(Color("DarkStaleBlue"))
                            
                            if Double(depositBalance)! > Double(currency)! {
                                HStack {
                                    Text("Deposit Exceeds Active Balance".localized(language))
                                        .font(.custom("Montserrat-Bold", size: 10))
                                    Spacer()
                                }
                                .foregroundColor(.red)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total Active Balance".localized(language))
                                    .font(.custom("Montserrat-Bold", size: 10))
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                HStack(alignment: .top, spacing: 0) {
                                    Text("Rp.")
                                        .font(.custom("Montserrat-Bold", size: 10))
                                    Text(productsSavingAccountVM.currency.thousandSeparator())
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
                    
                    SavingAccountDetailRow(label: "Minimum Initial Deposit".localized(language), value: productsSavingAccountVM.minimumSetoranAwal)
                    
                    //                    SavingAccountDetailRow(label: "Minimum Deposit Next".localized(language), value: productsSavingAccountVM.minimumSetoranAwal)
                    
                    SavingAccountDetailRow(label: "Minimum Balance".localized(language), value: productsSavingAccountVM.minimumSaldo)
                    
                    SavingAccountDetailRow(label: "Biaya Administratif / Bulan", value: productsSavingAccountVM.biayaAdministrasi)
                }
                .padding(.top, 20)
                .padding(.bottom, 85)
                
            }
            
            VStack {
                Spacer()
                VStack {
                    NavigationLink(destination: ConfirmationOfTransactionSavingAccountView(), label: {
                        Text("OPENING CONFIRMATION".localized(language))
                            .padding()
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .background(nextBtnDisabled ? Color(.lightGray) : Color("StaleBlue"))
                            .cornerRadius(15)
                    })
                    .disabled(nextBtnDisabled)
                    .padding(.horizontal, 25)
                }
                .frame(maxWidth: .infinity, maxHeight: 65)
                .background(Color.white)
                .shadow(color: Color("StaleBlue").opacity(0.2), radius: 10, x: 2, y: 0)
            }
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear{
            self.productsSavingAccountVM.getProductsDetails(planCode: "") { (result) in
                
            }
        }
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
        ConfirmationOfOpeningSavingAccountView(product: .constant(""))
    }
}
