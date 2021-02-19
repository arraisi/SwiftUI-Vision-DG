//
//  TransferScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct TransferTabs: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var isRouteTransferOnUs: Bool = false
    @State private var isRouteTransferOffUs: Bool = false
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            
            GeometryReader { geometry in
                Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                    .frame(height: 0)
            }
            
            VStack {
                titleInfo
                buttonLink
                
                VStack {
                    HStack {
                        Text("Last Transaction")
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    EmptyView()
                        .padding(.bottom)
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
            }
        })
        .navigationBarHidden(true)
        .onReceive(self.appState.$moveToTransfer) { moveToTransfer in
            if moveToTransfer {
                print("Move to Transfer: \(moveToTransfer)")
                self.isRouteTransferOnUs = false
                self.isRouteTransferOffUs = false
                self.appState.moveToTransfer = false
            }
        }
    }
    
    // MARK: -USERNAME INFO VIEW
    var titleInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Transfer")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Silahkan Pilih Jenis Transaksi Untuk Digunakan")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_search")
            })
        }
        .padding()
    }
    
    var buttonLink: some View {
        VStack {
            
            // Link Transfer ONUS
            NavigationLink(
                destination: TransferOnUsScreen(),
                isActive: self.$isRouteTransferOnUs) {
                EmptyView()
            }
//            .isDetailLink(false)
            
            // Link Transfer OFFUS
            NavigationLink(
                destination: TransferRtgsScreen(),
                isActive: self.$isRouteTransferOffUs,
                label: {EmptyView()}
            )
//            .isDetailLink(false)
            
            Button(action: {
                print("ONUS")
                self.isRouteTransferOnUs = true
            }, label: {
                Text("SESAMA BANK MESTIKA")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                
            })
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Spacer(minLength: 10)
            
            Button(action: {
                print("OFFUS")
                self.isRouteTransferOffUs = true
            }, label: {
                Text("TRANSFER KE BANK LAIN")
                    .foregroundColor(Color(hex: "#2334D0"))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                
            })
            .background(Color.white)
            .cornerRadius(12)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding([.bottom, .top], 20)
    }
}

struct TransferTabs_Previews: PreviewProvider {
    static var previews: some View {
        TransferTabs(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
