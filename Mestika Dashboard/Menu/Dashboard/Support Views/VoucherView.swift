//
//  VoucherView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 22/10/20.
//

import SwiftUI

struct VoucherView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Voucher")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    
                    Text("Transactions are more profitable by using vouchers.".localized(language))
                        .font(.caption)
                        .fontWeight(.ultraLight)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Image("ic_voucher")
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            
            VStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Show All Vouchers".localized(language))
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            }
            .padding(.bottom, 20)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
}

struct VoucherView_Previews: PreviewProvider {
    static var previews: some View {
        VoucherView()
    }
}
