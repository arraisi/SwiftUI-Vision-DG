//
//  TransactionLimitView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 07/05/21.
//

import SwiftUI

struct TransactionLimitView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var limitTarikTunai: Double = 0
    @State var limitTarikTunaiTxt: String = ""
    
    @State var limitTransferAntarSesama: Double = 0
    @State var limitTransferAntarSesamaTxt: String = ""
    
    @State var limitTransferAntarBank: Double = 0
    @State var limitTransferAntarBankTxt: String = ""
    
    @State var limitTransaksiDebit: Double = 0
    @State var limitTransaksiDebitTxt: String = ""
    
    var formatter = NumberFormatter()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading) {
                            Text("Limit Tarikan Tunai")
                            Slider(value: $limitTarikTunai, in: 10000...7000000)
                                .onChange(of: limitTarikTunai, perform: { value in
                                    limitTarikTunaiTxt = String(format: "%.0f", value)
                                })
                            InputTransactionLimit(min: "10000", value: $limitTarikTunai, txtValue: $limitTarikTunaiTxt, max: "7000000")
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Limit Transfer Antar Sesama")
                            Slider(value: $limitTransferAntarSesama, in: 10000...15000000)
                                .onChange(of: limitTransferAntarSesama, perform: { value in
                                    limitTransferAntarSesamaTxt = String(format: "%.0f", value)
                                })
                            InputTransactionLimit(min: "10000", value: $limitTransferAntarSesama, txtValue: $limitTransferAntarSesamaTxt, max: "15000000")
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Limit Transfer Antar Bank")
                            Slider(value: $limitTransferAntarBank, in: 10000...5000000)
                                .onChange(of: limitTransferAntarBank, perform: { value in
                                    limitTransferAntarBankTxt = String(format: "%.0f", value)
                                })
                            InputTransactionLimit(min: "10000", value: $limitTransferAntarBank, txtValue: $limitTransferAntarBankTxt, max: "5000000")
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            Text("Limit Transaksi Debit")
                            Slider(value: $limitTransaksiDebit, in: 10000...10000000)
                                .onChange(of: limitTransaksiDebit, perform: { value in
                                    limitTransaksiDebitTxt = String(format: "%.0f", value)
                                })
                            InputTransactionLimit(min: "10000", value: $limitTransaksiDebit, txtValue: $limitTransaksiDebitTxt, max: "10000000")
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                }
                
                
                Spacer()
                
                buttonGroup()
            }
        }
        .navigationBarTitle("Transaction Limit", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
    
    func valueRow(min: String, value: Double, max: String) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Min.")
                    .font(.custom("Montserrat-SemiBold", size: 14))
                Text(min.thousandSeparator())
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(Color("StaleBlue"))
            }
            Spacer()
            
            Text("\(Int(value))".thousandSeparator())
                .font(.custom("Montserrat-SemiBold", size: 16))
                .padding(10)
                .frame(width: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.lightGray), lineWidth: 2)
                )
            
            Spacer()
            VStack(alignment: .trailing) {
                Text("Max.")
                    .font(.custom("Montserrat-SemiBold", size: 14))
                Text(max.thousandSeparator())
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(Color("StaleBlue"))
            }
        }
    }
    
    func buttonGroup() -> some View {
        
        VStack {
            HStack(alignment: .center){
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                })
                .background(Color(.lightGray))
                .cornerRadius(10)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("OK")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                })
                .background(Color("StaleBlue"))
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            
        }
        .padding(5)
        .background(Color.white)
    }
}

struct InputTransactionLimit: View {
    
    var min: String
    @Binding var value: Double
    @Binding var txtValue: String
    var max: String
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Min.")
                    .font(.custom("Montserrat-SemiBold", size: 14))
                Text(min.thousandSeparator())
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(Color("StaleBlue"))
            }
            
            Spacer()
            
            TextField("0", text: $txtValue)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: txtValue, perform: { value in
                    self.value = Double(value) ?? 0
                })
                .keyboardType(.numberPad)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Max.")
                    .font(.custom("Montserrat-SemiBold", size: 14))
                Text(max.thousandSeparator())
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(Color("StaleBlue"))
            }
        }
    }
}

struct TransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionLimitView()
    }
}
