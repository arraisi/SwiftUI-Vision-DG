//
//  TransactionLimitView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 07/05/21.
//

import SwiftUI

struct TransactionLimitView: View {
    
    @State var trxOnUsMilikSendiriRp: Double = 0
    @State var trxOnUsMilikSendiriRpTxt: String = ""
    
    @State var trxOnUsMilikSendiriNonRp: Double = 0
    @State var trxOnUsMilikSendiriNonRpTxt: String = ""
    
    @State var trxOnUsRp: Double = 0
    @State var trxOnUsRpTxt: String = ""
    
    @State var trxOnUsNonRp: Double = 0
    @State var trxOnUsNonRpTxt: String = ""
    
    @State var trxVirtualAkun: Double = 0
    @State var trxVirtualAkunTxt: String = ""
    
    @State var trxSKN: Double = 0
    @State var trxSKNTxt: String = ""
    
    @State var trxRTGS: Double = 0
    @State var trxRTGSTxt: String = ""
    
    @State var trxIBFT: Double = 0
    @State var trxIBFTTxt: String = ""
    
    @State var trxPembayaran: Double = 0
    @State var trxPembayaranTxt: String = ""
    
    @State var trxPembelian: Double = 0
    @State var trxPembelianTxt: String = ""
    
    @State private var pinActive: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center) {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 20) {
                        
                        TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Rupiah)", min: 10000, value: $trxOnUsMilikSendiriRp, txtValue: $trxOnUsMilikSendiriRpTxt, max: 1000000000)
                        
                        TrasactionLimitRow(lable: "Transfer internal rekening milik sendiri (Non Rupiah)", min: 10000, value: $trxOnUsMilikSendiriNonRp, txtValue: $trxOnUsMilikSendiriNonRpTxt, max: 10000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi on us (Rupiah)", min: 10000, value: $trxOnUsRp, txtValue: $trxOnUsRpTxt, max: 1000000000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi on us (Non Rupiah)", min: 10000, value: $trxOnUsNonRp, txtValue: $trxOnUsNonRpTxt, max: 10000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi virtual akun", min: 10000, value: $trxVirtualAkun, txtValue: $trxVirtualAkunTxt, max: 50000000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi SKN", min: 10000, value: $trxSKN, txtValue: $trxSKNTxt, max: 250000000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi RTGS", min: 10000, value: $trxRTGS, txtValue: $trxRTGSTxt, max: 1000000000)
                        
                        TrasactionLimitRow(lable: "Limit transaksi IBFT", min: 10000, value: $trxIBFT, txtValue: $trxIBFTTxt, max: 50000000)
                        
                        TrasactionLimitRow(lable: "Limit pembayaran tagihan", min: 10000, value: $trxPembayaran, txtValue: $trxPembayaranTxt, max: 10000000)
                        
                        TrasactionLimitRow(lable: "Limit pembelian", min: 10000, value: $trxPembelian, txtValue: $trxPembelianTxt, max: 10000000)
                        
                    }
                    .padding()
                    .padding(.top, 20)
                }
                
                
                Spacer()
                
                VStack {
                    HStack(alignment: .center){
                        NavigationLink(destination: PinTransactionLimitView(), isActive: $pinActive, label: {EmptyView()
                        })
                        
                        Button(action: {
                            self.pinActive = true
                        }, label: {
                            Text("SIMPAN")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 40)
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
}

struct TransactionLimitView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionLimitView()
        }
    }
}
