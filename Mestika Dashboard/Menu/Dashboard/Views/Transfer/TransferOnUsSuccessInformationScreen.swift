//
//  TransferOnUsSuccessInformationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsSuccessInformationScreen: View {
    
//    @EnvironmentObject var transferData: TransferOnUsModel
    var transferData: TransferOnUsModel
    
    @State private var showPopover: Bool = false
    @State var receivedBank = "Mestika"
    
    @State private var uiImage: UIImage = UIImage()
    @State private var sheet = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg_blue")
                    .resizable()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                ZStack {
                    
                    VStack {
                        Spacer()
                        Image("logo_m_mestika")
                            .resizable()
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding()
                        
                        dateInfo
                        nominalInfo
                        destinationInfo
                        receivedInfo
                        
                        Spacer(minLength: 0)
                        NavigationLink(destination: TransferOnUsDetailsInformation().environmentObject(transferData), label: {
                            Text("Lihat Detail Transaksi")
                                .foregroundColor(Color(hex: "#2334D0"))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                            
                        })
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                        
                        Spacer(minLength: 0)
                    }
        
                    if self.showPopover {
                        ModalOverlay(tapAction: { withAnimation { self.showPopover = false } })
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    }
                    
                    if showPopover {
                        PopOverFavoriteView()
                            .onTapGesture {
                                self.showPopover.toggle()
                            }
                    }
                }
            
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: HStack(spacing: 30) {
                HStack {
                    Text("Tambahkan ke Favorit?")
    //                    .font(.caption)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        withAnimation(.easeIn) {
                            self.showPopover.toggle()
                        }
                    }, label: {
                        Image(systemName: "pin")
                            .foregroundColor(.white)
                    })
                    
                }
                
                Button(action: {
                    self.uiImage = self.asUIImage()
                    shareImage()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.white)
                })
            })
        }.onAppear() {
        }
    }
    
    var dateInfo: some View {
        VStack {
            Text("13 September 2020")
//                .font(.caption)
                .foregroundColor(.white)
                .fontWeight(.semibold)
            
            Text("Transfer Sesama Berhasil")
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
    
    var nominalInfo: some View {
        VStack {
            Text("Nominal Transaksi")
//                .font(.caption)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            HStack(alignment: .top) {
                Text("Rp.")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text(self.transferData.amount.thousandSeparator())
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold, design: .default))
            }
        }
        .padding(.vertical, 30)
    }
    
    var destinationInfo: some View {
        VStack(alignment: .leading) {
            Text("Ke")
//                .font(.caption2)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Text(self.transferData.destinationName.uppercased())
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            HStack {
                Text("Mestika :")
//                    .font(.caption2)
                    .foregroundColor(Color(hex: "#FFFFFF"))
                
                Text(self.transferData.destinationNumber)
//                    .font(.caption2)
                    .foregroundColor(Color(hex: "#FFFFFF"))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    var receivedInfo: some View {
        VStack(alignment: .leading) {
            Text("Dari")
//                .font(.caption2)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Text("PRIMA JATNIKA")
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            HStack {
                Text(self.transferData.sourceNumber)
//                    .font(.caption2)
                    .foregroundColor(Color(hex: "#FFFFFF"))
                
                Text("(\(self.transferData.sourceAccountName))")
//                    .font(.caption2)
                    .foregroundColor(Color(hex: "#FFFFFF"))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    func shareImage() {
        sheet.toggle()
        let av = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct TransferOnUsSuccessInformationScreen_Previews: PreviewProvider {
    static var previews: some View {
        TransferOnUsSuccessInformationScreen(transferData: TransferOnUsModel())
    }
}

struct ArrowShape: Shape {
    func path (in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}
