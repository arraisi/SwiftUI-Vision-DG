//
//  HistoryDetailView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 03/05/21.
//

import SwiftUI

struct HistoryDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var data: HistoryModelElement
    
    var body: some View {
        VStack {
            HistoryDetailAppBar
            HistoryPDFView
            Spacer()
        }
        .navigationBarHidden(true)
        //        .navigationBarItems(trailing: VStack{
        //            Button(action: {
        //                exportToPDF()
        //            }, label: {
        //                Image(systemName: "tray.and.arrow.down")
        //                    .font(.system(size: 24))
        //                    .padding(.horizontal, 5)
        //            })
        //        })
    }
    
    var HistoryDetailAppBar: some View {
        ZStack {
            Color("DarkStaleBlue")
                .edgesIgnoringSafeArea(.all)
            HStack(spacing: 0) {
                Button(action: {
                    UINavigationBar.appearance().tintColor = UIColor.white
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        
                        Text("Back")
                            .foregroundColor(.white)
                    }
                })
                
                Spacer()
                
                Button(action: {
                    exportToPDF()
                }, label: {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 24))
                        .padding(.horizontal, 5)
                        .foregroundColor(.white)
                })
            }
            .padding([.horizontal, .bottom], 10)
        }.frame(height: 40)
    }
    
    var HistoryPDFView: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 5) {
                Image("logo_m_mestika")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color("DarkStaleBlue"))
                    .frame(width: 80, height: 80)
                    .padding(5)
                    .padding(.top, 20)
                
                Text(data.status == 0 ? "Berhasil" : "Gagal")
                    .font(.custom("Montserrat-Bold", size: 16))
                
                Text("Waktu : \(data.transactionDate ?? "")")
                
                Text("Reff : \(data.reffNumber ?? "")")
            }
            
            VStack {
                HStack {
                    Text("Sumber rekening")
                    Spacer()
                    Text(data.data.sourceAccount ?? "")
                }
                
                HStack {
                    Text("Rekening tujuan")
                    Spacer()
                    Text(data.data.destinationAccount ?? "")
                }
            }
            
            VStack {
                HStack {
                    HStack {
                        Text("Bank tujuan")
                        Spacer()
                    }
                    .frame(width: 120)
                    
                    Text(data.data.destinationBank ?? "")
                    Spacer()
                }
                HStack {
                    HStack {
                        Text("Deskripsi")
                        Spacer()
                    }
                    .frame(width: 120)
                    Text(data.data.trxMessage ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
            
            VStack {
                
                Divider()
                
                HStack {
                    Text("Nominal transaksi :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Fee transaksi :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Voucher :")
                    Spacer()
                    Text("")
                }
                
                HStack {
                    Text("Total transaksi :")
                    Spacer()
                    Text(data.data.amount?.thousandSeparator() ?? "")
                }
                
                Divider()
            }
            Spacer()
        }
        .font(.custom("Montserrat-Medium", size: 14))
        .padding(.horizontal, 30)
        
    }
    
    func exportToPDF() {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("ReceiptTrxMestika.pdf")
        let pageSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        //        let rootVC = UIApplication.shared.windows.first?.rootViewController
        
        //View to render on PDF
        let myUIHostingController = UIHostingController(rootView: HistoryPDFView)
        myUIHostingController.view.frame = CGRect(origin: .zero, size: pageSize)
        
        //Render the view behind all other views
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            print("ERROR: Could not find root ViewController.")
            return
        }
        rootVC.addChild(myUIHostingController)
        //at: 0 -> draws behind all other views
        //at: UIApplication.shared.windows.count -> draw in front
        rootVC.view.insertSubview(myUIHostingController.view, at: 0)
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        DispatchQueue.main.async {
            do {
                try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                    context.beginPage()
                    myUIHostingController.view.layer.render(in: context.cgContext)
                })
                print("wrote file to: \(outputFileURL.path)")
                actionSheet(urlShare: outputFileURL)
            } catch {
                print("Could not create PDF file: \(error.localizedDescription)")
            }
        }
    }
    
    func actionSheet(urlShare: URL) {
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryDetailView(data: HistoryModelElement(nik: "00000", deviceID: "123", transactionDate: "123", status: 0, message: "123", code: "00", trxType: "123", traceNumber: "123", reffNumber: "123", data: DataClass(transactionFee: "1000000", destinationBank: "123456", transactionAmount: "2000000", destinationAccountNumber: "123456", message: "Lorem ipsum lask ekahs lahsk alsdh kas. Lorem ipsum lask ekahs lahsk alsdh kas", sourceAccountNumber: "100", destinationAccountName: "AA", sourceAccountName: "BB", amount: "4000000", destinationAccount: "123", referenceNumber: "x123", sourceAccount: "b123", trxMessage: "Message")))
        }
    }
}
