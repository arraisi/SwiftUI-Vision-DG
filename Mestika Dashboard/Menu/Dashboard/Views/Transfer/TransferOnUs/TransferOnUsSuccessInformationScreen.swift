//
//  TransferOnUsSuccessInformationScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 26/10/20.
//

import SwiftUI

struct TransferOnUsSuccessInformationScreen: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State var status: String = ""
    @State var message: String = ""
    
//    @EnvironmentObject var transferData: TransferOnUsModel
    var transferData: TransferOnUsModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showPopover: Bool = false
    @State var receivedBank = "Mestika"
    
    @State private var uiImage: UIImage = UIImage()
    @State private var sheet = false
    @State private var dateString = ""
    
    @State var showingBadge: Bool = false
    
    var body: some View {
        ZStack {
            Image("bg_blue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .center) {
                    Spacer()
                    Image("logo_m_mestika")
                        .resizable()
                        .frame(width: 70, height: 70, alignment: .center)
                        .padding()
                    
                    dateInfo
                    nominalInfo
                    destinationInfo
                    receivedInfo
                    
                    Spacer(minLength: 0)
                    
                    Button(
                        action: {
                            self.appState.moveToTransfer = true
                        },
                        label: {
                            Text("Back to Main Page".localized(language))
                                .foregroundColor(Color(hex: "#2334D0"))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.leading, 20)
                        .padding(.trailing, 10)
                    Spacer(minLength: 0)
                }
            }
            
            if self.showPopover {
                ModalOverlay(tapAction: { withAnimation { self.showPopover = false } })
                    .edgesIgnoringSafeArea(.all)
            }
            
            if showPopover {
                PopOverFavoriteView(transferData: transferData, show: self.$showPopover, showAlert: self.$showingBadge, status: self.$status, message: self.$message)
                    .padding(30)
            }
        
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingBadge) {
            return Alert(
                title: Text("\(self.status)".localized(language)),
                message: Text("\(self.message)".localized(language)),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
        .navigationBarItems(trailing: HStack(spacing: 30) {
            HStack {
                Text("Add to favorites?".localized(language))
                    .font(.caption)
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
        }).onAppear() {
            initDate()
        }
    }
    
    var dateInfo: some View {
        VStack {
            Text(self.transferData.trxDateResp)
                .foregroundColor(.white)
                .fontWeight(.semibold)
            
            Text("Peer Transfer Succeed".localized(language))
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
    
    var nominalInfo: some View {
        VStack {
            Text("Nominal Transaction".localized(language))
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
            Text("To".localized(language))
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
            Text("From".localized(language))
//                .font(.caption2)
                .foregroundColor(Color(hex: "#FFFFFF"))
            
            Text(self.transferData.username)
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
    
    func initDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        self.dateString = formatter.string(from: Date())
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
