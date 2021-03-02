//
//  ListAllFavoriteTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoriteTransactionView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var searchCtrl = ""
    
    //    var action: ((FavoritModelElement) -> Void)?
    @State private var activeDetails: Bool = false
    
    @State private var showingDetail = false
    
    @State private var isShowingAlert = false
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    @State private var showPopover: Bool = false
    
    var cardNo: String = ""
    var sourceNumber: String = ""
    @State var destinationNumber: String = ""
    
    @State var isRouteOnUs: Bool = false
    @State var isRouteOffUs: Bool = false
    
    @State var transferDataOnUs = TransferOnUsModel()
    @State var transferDataOffUs = TransferOffUsModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            VStack {
                searchCard
                
                VStack {
                    
                    HStack {
                        Text("Favorit Transfer")
                            .foregroundColor(Color(hex: "#1D2238"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    
                    NavigationLink(
                        destination: TransferOnUsScreen(dest: .constant(destinationNumber)).environmentObject(transferDataOnUs),
                        isActive: self.$isRouteOnUs,
                        label: {EmptyView()}
                    )
                    .isDetailLink(false)
                    
                    NavigationLink(
                        destination: TransferRtgsScreen(dest: .constant(destinationNumber)).environmentObject(transferDataOffUs),
                        isActive: self.$isRouteOffUs,
                        label: {EmptyView()}
                    )
                    .isDetailLink(false)
                    
                    List(self.favoritVM.favorites.reversed(), id: \.id) { data in
                        HStack {
                            
                            Button(
                                action: {
                                    if (data.type == "TRANSFER_SESAMA") {
                                        self.destinationNumber = data.transferOnUs!.destinationNumber
                                        self.isRouteOnUs = true
                                    } else {
                                        self.destinationNumber = data.transferOffUsRtgs!.accountTo
                                        self.isRouteOffUs = true
                                    }
                                },
                                label: {
                                    ZStack {
                                        Circle()
                                            .fill(Color.secondary)
                                            .frame(width: 30, height: 30)
                                        
                                        Text(data.name.prefix(1))
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(data.name)")
                                            .font(.custom("Montserrat-SemiBold", size: 14))
                                        
                                        HStack {
                                            Text("\(data.bankName) : \(data.type == "TRANSFER_SESAMA" ? data.transferOnUs!.destinationNumber : data.transferOffUsRtgs!.accountTo)")
                                                .font(.custom("Montserrat-Light", size: 14))
                                        }
                                    }
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                self.showingDetail = true
                            }, label: {
                                Image(systemName: "ellipsis")
                            })
                            .buttonStyle(PlainButtonStyle())
                            .alert(isPresented: $isShowingAlert) {
                                return Alert(
                                    title: Text("Anda Yakin ingin menghapus \(data.name)"),
                                    primaryButton: .default(Text("IYA"), action: {
                                        self.favoritVM.remove(data: data) { result in
                                            print("result remove favorite \(result)")
                                            if result {
                                                getList()
                                            }
                                        }
                                    }),
                                    secondaryButton: .cancel(Text("TIDAK")))
                            }
                            .actionSheet(isPresented: self.$showingDetail) {
                                ActionSheet(title: Text("Pilihan"), message: Text("Pilih menu dibawah ini"), buttons: [.default(Text("Hapus"), action: {
                                    print("Hapus")
                                    self.isShowingAlert = true
                                }), .default(Text("Edit"), action: {
                                    print("Edit")
                                    if (data.type == "TRANSFER_SESAMA") {
                                        self.transferDataOnUs.destinationName = data.name
                                        self.transferDataOnUs.destinationNumber = data.transferOnUs!.destinationNumber
                                        self.transferDataOnUs.cardNo = data.cardNo
                                        self.transferDataOnUs.idEdit = data.id
                                        self.showPopover = true
                                    } else {
                                    }
                                }), .cancel({
                                    
                                })])
                            }
                            
                        }
                    }
                    .listStyle(PlainListStyle())
                    .colorMultiply(Color(hex: "#F6F8FB"))
                    .frame(height: 500)
                }
                .frame(width: UIScreen.main.bounds.width - 10)
            }
            
            if self.showPopover {
                ModalOverlay(tapAction: { withAnimation { self.showPopover = false } })
            }
            
            if showPopover {
                PopOverEditFavoriteOnUsView(transferData: transferDataOnUs, show: self.$showPopover, showAlert: .constant(false))
                    .padding(30)
            }
        }
        .onAppear(perform: getList)
    }
    
    var searchCard: some View {
        HStack {
            HStack {
                TextField("Cari kontak Transfer", text: $searchCtrl, onEditingChanged: { changed in
                    print("\($searchCtrl)")
                })
                
                Image("ic_search")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            }
            .keyboardType(.numberPad)
            .frame(height: 10)
            .font(.subheadline)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.leading, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("ic_fillter")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
            })
            .frame(height: 10)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.trailing, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
        }
        .padding([.bottom], 20)
    }
    
    func getList() {
        self.favoritVM.getList(cardNo: self.cardNo, sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
}

struct ListAllFavoriteTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListAllFavoriteTransactionView()
    }
}
