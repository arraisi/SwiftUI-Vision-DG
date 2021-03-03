//
//  ListAllFavoriteTransactionView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/10/20.
//

import SwiftUI

struct ListAllFavoriteTransactionView: View {
    
    @State var receivedName = ""
    @State var receivedBank = "MESTIKA"
    
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
    @State var type: String = ""
    @State var destinationBank: String = ""
    
    @State var isRouteOnUs: Bool = false
    @State var isRouteOffUs: Bool = false
    
    @State var transferDataOnUs = TransferOnUsModel()
    @State var transferDataOffUs = TransferOffUsModel()
    
    var body: some View {
        ZStack {
            Color(hex: "#F6F8FB")
            
            ScrollView {
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
                        destination: TransferRtgsScreen(dest: .constant(destinationNumber), type: .constant(type), destBank: .constant(destinationBank)).environmentObject(transferDataOffUs),
                        isActive: self.$isRouteOffUs,
                        label: {EmptyView()}
                    )
                    .isDetailLink(false)
                    
                    List(self.favoritVM.favorites.reversed(), id: \.id) { data in
                        HStack {
                            
                            Button(
                                action: {
                                    if (data.type == "TRANSFER_SESAMA") {
                                        print("ON US")
                                        self.destinationNumber = data.transferOnUs!.destinationNumber
                                        self.isRouteOnUs = true
                                    } else {
                                        print("OFF US")
                                        if (data.transferOffUsRtgs == nil) {
                                            self.destinationNumber = data.transferOffUsSkn!.accountTo
                                            self.destinationBank = data.bankName
                                            self.type = "SKN"
                                            self.isRouteOffUs = true
                                        } else {
                                            self.destinationNumber = data.transferOffUsRtgs!.accountTo
                                            self.destinationBank = data.bankName
                                            self.type = "RTGS"
                                            self.isRouteOffUs = true
                                        }
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
                                            if (data.type == "TRANSFER_SESAMA") {
                                                Text("\(data.bankName) : \(data.transferOnUs!.destinationNumber)")
                                                    .font(.custom("Montserrat-Light", size: 14))
                                            } else {
                                                if (data.transferOffUsRtgs == nil) {
                                                    Text("\(data.bankName) : \(data.transferOffUsSkn!.accountTo)")
                                                        .font(.custom("Montserrat-Light", size: 14))
                                                } else {
                                                    Text("\(data.bankName) : \(data.transferOffUsRtgs!.accountTo)")
                                                        .font(.custom("Montserrat-Light", size: 14))
                                                }
                                            }
                                        }
                                    }
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Button(action: {
                                print("\(data.name)")
                                if (data.type == "TRANSFER_SESAMA") {
                                    self.receivedName = data.name
                                    self.transferDataOnUs.destinationName = data.name
                                    self.transferDataOnUs.sourceNumber = data.transferOnUs!.sourceNumber
                                    self.transferDataOnUs.cardNo = data.cardNo
                                    self.transferDataOnUs.idEdit = data.id
                                } else {
                                    
                                    if (data.transferOffUsRtgs == nil) {
                                        self.transferDataOnUs.destinationName = data.name
                                        self.transferDataOnUs.sourceNumber = data.transferOffUsSkn!.sourceNumber
                                        self.transferDataOnUs.cardNo = data.cardNo
                                        self.transferDataOnUs.idEdit = data.id
                                    } else {
                                        self.transferDataOnUs.destinationName = data.name
                                        self.transferDataOnUs.sourceNumber = data.transferOffUsRtgs!.sourceNumber
                                        self.transferDataOnUs.cardNo = data.cardNo
                                        self.transferDataOnUs.idEdit = data.id
                                    }
                                    
                                }
                                self.showingDetail = true
                            }, label: {
                                Image(systemName: "ellipsis")
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
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
                                self.showPopover = true
                               
                            }), .cancel({
                                
                            })])
                        }
                    }
                    .listStyle(PlainListStyle())
                    .colorMultiply(Color(hex: "#F6F8FB"))
                    .frame(height: 500)
                }
                .frame(width: UIScreen.main.bounds.width - 10)
                
                Spacer()
            }
            
            if self.showPopover {
                ModalOverlay(tapAction: { withAnimation { self.showPopover = false } })
            }
            
            if showPopover {
                popupEdit
                    .padding(30)
                    
            }
        }
        .onAppear {
            self.isRouteOnUs = false
            self.isRouteOffUs = false
            getList()
        }
    }
    
    var popupEdit: some View {
        VStack {
            VStack {
                HStack {
                    Text("Edit Kontrak Transfer")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Nama Kontrak Penerima")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        TextField("Nama Kontak Penerima", text: self.$receivedName, onEditingChanged: { changed in
                            self.transferDataOnUs.destinationName = self.receivedName
                            print("\($receivedName)")
                        })
                        .disabled(false)
                        .frame(height: 10)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .padding()
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 25)
                    
                    HStack {
                        Text("Detail Rekening")
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Bank Form
                    HStack(spacing: 20) {
                        
                        HStack {
                            Text("Bank")
                                .font(.caption)
                                .fontWeight(.light)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 60)
                        
                        TextField("Bank", text: $receivedBank, onEditingChanged: { changed in
                            print("\($receivedBank)")
                        })
                        .disabled(true)
                        .frame(height: 10)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    // No. Rekening Form
                    HStack(spacing: 20) {
                        Text("No. Rekening")
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100)
                        
                        TextField("No. Rekening", text: .constant(transferDataOnUs.sourceNumber), onEditingChanged: { changed in
                            //                            print("\($receivedRekening)")
                        })
                        .disabled(true)
                        .frame(height: 10)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    
                    Button(action: {
                        self.transferDataOnUs.destinationName = self.receivedName
                        
                        self.favoritVM.updateWithParam(id: self.transferDataOnUs.idEdit, cardNo: self.transferDataOnUs.cardNo, sourceNumber: self.transferDataOnUs.sourceNumber, name: self.transferDataOnUs.destinationName) { success in
                            
                            if success {
                                self.showPopover = false
                                getList()
                            }
                            
                            if !success {
                                
                            }
                            
                        }
                    }, label: {
                        if self.favoritVM.isLoading {
                            ProgressView()
                        } else {
                            Text("SIMPAN PERUBAHAN")
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                        }
                    })
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    .disabled(disableForm)
                    .background(disableForm ? Color(.lightGray) : Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 40)
                }
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            .padding(.top, 20)
            
            Spacer()
        }
        .onAppear {
            self.receivedName = self.transferDataOnUs.destinationName
        }
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
        .padding([.bottom, .top], 20)
    }
    
    func getList() {
        self.favoritVM.getList(cardNo: self.cardNo, sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
    
    var disableForm: Bool {
        receivedName.isEmpty || self.favoritVM.isLoading
    }
}
