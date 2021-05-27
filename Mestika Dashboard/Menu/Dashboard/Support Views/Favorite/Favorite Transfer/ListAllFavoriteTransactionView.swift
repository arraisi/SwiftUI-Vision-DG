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
    @State private var filterCtrl = "Type Filter"
    
    var _listFilterType = ["All", "Mestika", "Online", "SKN", "RTGS"]
    
    //    var action: ((FavoritModelElement) -> Void)?
    @State private var activeDetails: Bool = false
    
    @State private var showingDetail = false
    
    @State private var isShowingAlert = false
    
    @StateObject private var favoritVM = FavoritViewModel()
    
    @State private var showPopover: Bool = false
    @State private var showPopoverFilter: Bool = false
    
    var cardNo: String = ""
    var sourceNumber: String = ""
    @State var destinationNumber: String = ""
    @State var type: String = ""
    @State var destinationBank: String = ""
    @State var name: String = ""
    @State var desc: String = ""
    
    @State var isRouteOnUs: Bool = false
    @State var isRouteOffUs: Bool = false
    
    @State var transferDataOnUs = TransferOnUsModel()
    @State var transferDataOffUs = TransferOffUsModel()
    
    @State var showAlertEdit: Bool = false
    @State var showAlert: Bool = false
    @State var alert: String = ""
    
    @State var showFreezeMenu: Bool = false
    
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
                        destination: TransferRtgsScreen(dest: .constant(destinationNumber), type: .constant(type), destBank: .constant(destinationBank), nameCst: .constant(name), desc: .constant(desc)).environmentObject(transferDataOffUs),
                        isActive: self.$isRouteOffUs,
                        label: {EmptyView()}
                    )
                    .isDetailLink(false)
                    
                    List(self.favoritVM.favorites.reversed(), id: \.id) { data in
                        HStack {
                            
                            Button(
                                action: {
                                    if (self.profileVM.freezeAccount) {
                                        self.showFreezeMenu = true
                                    } else {
                                        if (data.type == "TRANSFER_SESAMA") {
                                            print("ON US")
                                            self.destinationNumber = data.transferOnUs!.destinationNumber
                                            self.isRouteOnUs = true
                                        } else {
                                            print("OFF US")
                                            if (data.transferOffUsRtgs == nil) {
                                                self.destinationNumber = data.transferOffUsSkn!.accountTo
                                                self.name = data.name
                                                self.desc = data.transferOffUsSkn!.transferOffUsSknDescription
                                                self.destinationBank = "data.bankName"
                                                self.type = "SKN"
                                                self.isRouteOffUs = true
                                            } else {
    //                                            self.destinationNumber = data.transferOffUsRtgs!.accountTo
                                                self.destinationBank = "data.bankName"
                                                self.name = data.name
    //                                            self.desc = data.transferOffUsRtgs!.transferOffUsRtgsDescription
                                                self.type = "RTGS"
                                                self.isRouteOffUs = true
                                            }
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
                                                Text("\(data.transferOnUs!.destinationNumber)")
                                                    .font(.custom("Montserrat-Light", size: 14))
                                            } else {
                                                if (data.transferOffUsRtgs == nil) {
                                                    Text("\(data.transferOffUsSkn!.accountTo)")
                                                        .font(.custom("Montserrat-Light", size: 14))
                                                } else {
//                                                    Text("\(data.bankName) : \(data.transferOffUsRtgs!.accountTo)")
//                                                        .font(.custom("Montserrat-Light", size: 14))
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
//                                    self.transferDataOnUs.sourceNumber = data.transferOnUs!.sourceNumber
                                    self.transferDataOnUs.destinationNumber = data.transferOnUs!.destinationNumber
                                    self.transferDataOnUs.cardNo = data.cardNo
                                    self.transferDataOnUs.idEdit = data.id
                                } else {
                                    
                                    if (data.transferOffUsRtgs == nil) {
                                        self.transferDataOnUs.destinationName = data.name
                                        self.transferDataOnUs.sourceNumber = data.transferOffUsSkn!.sourceNumber
                                        self.transferDataOnUs.destinationNumber = data.transferOffUsSkn!.accountTo
                                        self.transferDataOnUs.cardNo = data.cardNo
                                        self.transferDataOnUs.idEdit = data.id
                                        self.receivedBank = "data.bankName"
                                    } else {
                                        self.transferDataOnUs.destinationName = data.name
//                                        self.transferDataOnUs.sourceNumber = data.transferOffUsRtgs!.sourceNumber
//                                        self.transferDataOnUs.destinationNumber = data.transferOffUsRtgs!.accountTo
                                        self.transferDataOnUs.cardNo = data.cardNo
                                        self.transferDataOnUs.idEdit = data.id
                                        self.receivedBank = "data.bankName"
                                    }
                                    
                                }
                                self.showingDetail = true
                            }, label: {
                                Image(systemName: "ellipsis")
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        .actionSheet(isPresented: self.$showingDetail) {
                            ActionSheet(title: Text("Selection"), message: Text("Select the menu below"), buttons: [.default(Text("Delete"), action: {
                                print("Hapus")
                                print(data.name)
                                self.alert = "REMOVE DATA"
                                self.showAlert = true
                            }), .default(Text("Edit"), action: {
                                print("Edit")
                                self.showPopover = true
                               
                            }), .cancel(Text("Cancel"))])
                        }
                    }
                    .listStyle(PlainListStyle())
                    .colorMultiply(Color(hex: "#F6F8FB"))
                    .frame(height: 500)
                }
                .frame(width: UIScreen.main.bounds.width - 10)
                
                Spacer()
            }
            
            if self.showPopover || self.showPopoverFilter || self.showFreezeMenu {
                ModalOverlay(tapAction: { withAnimation { } })
            }
            
            if showPopover {
                popupEdit
                    .padding(30)
            }
            
            if showPopoverFilter {
                popupFilter
                    .padding(30)
                    .padding(.top, 15)
            }
        }
        .onAppear {
            self.isRouteOnUs = false
            self.isRouteOffUs = false
            self.checkFreezeAccount()
            getList()
        }
        .popup(isPresented: $showFreezeMenu, type: .floater(verticalPadding: 200), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            popupFreezeAccount()
                .padding(.bottom, 40)
        }
        .alert(isPresented: $showAlert) {
            
            if (self.alert == "REMOVE") {
                return Alert(
                    title: Text("Succeed".localized(language)),
                    message: Text("Data Berhasil Dihapus"),
                    dismissButton: .default(Text("OK".localized(language)))
                )
            }
            
            if (self.alert == "REMOVE DATA") {
                return Alert(
                    title: Text("Anda Yakin ingin menghapus".localized(language) + " \(self.transferDataOnUs.destinationName)"),
                    primaryButton: .default(Text("YES".localized(language)), action: {
                        self.favoritVM.removeWithParam(id: self.transferDataOnUs.idEdit, cardNo: self.transferDataOnUs.cardNo, sourceNumber: self.transferDataOnUs.sourceNumber) { result in
                            print("result remove favorite \(result)")
                            if result {
                                self.alert = "REMOVE"
                                self.showAlert = true
                                getList()
                            }
                        }
                    }),
                    secondaryButton: .cancel(Text("NO".localized(language))))
            }
            
            return Alert(
                title: Text("Succeed".localized(language)),
                message: Text("Changes Saved Successfully".localized(language)),
                dismissButton: .default(Text("OK".localized(language)))
            )
        }
    }
    
    var popupEdit: some View {
        VStack {
            VStack {
                HStack {
                    Text("Change Transfer Contact".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Recipient's Contact Name".localized(language))
                            .font(.caption)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        TextField("Recipient's Contact Name".localized(language), text: self.$receivedName, onEditingChanged: { changed in
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
                        Text("Account Details".localized(language))
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
                        
                        MultilineTextField("Bank", text: .constant(receivedBank), onCommit: {
                            
                        })
                        .disabled(true)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    // No. Rekening Form
                    HStack(spacing: 20) {
                        Text("Account number".localized(language))
                            .font(.caption)
                            .fontWeight(.light)
                            .frame(width: 100)
                        
                        TextField("Account number".localized(language), text: .constant(transferDataOnUs.destinationNumber), onEditingChanged: { changed in
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
                                self.alert = "EDIT"
                                self.showAlert = true
                                getList()
                            }
                            
                            if !success {
                                self.showPopover = false
                                getList()
                            }
                            
                        }
                    }, label: {
                        if self.favoritVM.isLoading {
                            ProgressView()
                        } else {
                            Text("SAVE CHANGES".localized(language))
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    })
                    .foregroundColor(.white)
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
    
    // MARK: POPUP MESSAGE ERROR
    func popupFreezeAccount() -> some View {
        VStack(alignment: .leading) {
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .frame(width: 65, height: 65)
                .foregroundColor(.red)
                .padding(.top, 20)
            
            Text("Akun anda telah dibekukan".localized(language))
                .fontWeight(.bold)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding([.bottom, .top], 20)
            
            Button(action: {}) {
                Text("Back".localized(language))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Text("")
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    var popupFilter: some View {
        VStack {
            VStack {
                HStack {
                    Text("Based on the type of transfer".localized(language))
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading) {
                    VStack {
                        Menu {
                            ForEach(self._listFilterType, id: \.self) { data in
                                Button(action: {
                                    self.filterCtrl = data
                                }) {
                                    Text(data)
                                        .font(.custom("Montserrat-Regular", size: 12))
                                }
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(filterCtrl)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Image("ic_expand").padding()
                            }
                        }
                        .disabled(false)
                        .frame(height: 10)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .padding()
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                        .padding(.horizontal, 15)
                    }
                    
                    Button(action: {
                        self.showPopoverFilter = false
                        getListFilterType()
                    }, label: {
                        if self.favoritVM.isLoading {
                            ProgressView()
                        } else {
                            Text("Search")
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                    })
                    .foregroundColor(.white)
                    .disabled(disableFormFilter)
                    .background(disableFormFilter ? Color(.lightGray) : Color(hex: "#2334D0"))
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
                
                Button(
                    action: {
                        getListFilter()
                    },
                    label: {
                        Image("ic_search")
                            .renderingMode(.template)
                            .foregroundColor(.gray)
                    }
                )
            }
            .frame(height: 10)
            .font(.subheadline)
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            .padding(.leading, 20)
            .shadow(color: Color.gray.opacity(0.3), radius: 10)
            
            Button(action: {
                self.showPopoverFilter = true
            }, label: {
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
    
    func getListFilterType() {
        self.favoritVM.getListFavoriteFilterType(type: filterCtrl, cardNo: self.cardNo, sourceNumber: self.sourceNumber) { result in
            print(result)
        }
    }
    
    func getListFilter() {
        self.favoritVM.getListFavoriteFilter(searchText: self.searchCtrl, cardNo: self.cardNo, sourceNumber: self.sourceNumber) { result in
            print(result)
        }
    }
    
    func getList() {
        self.favoritVM.getList(cardNo: self.cardNo, sourceNumber: self.sourceNumber, completion: { result in
            print(result)
        })
    }
    
    @ObservedObject var profileVM = ProfileViewModel()
    func checkFreezeAccount() {
        self.profileVM.getAccountFreeze { sucess in }
    }
    
    var disableForm: Bool {
        receivedName.isEmpty || self.favoritVM.isLoading
    }
    
    var disableFormFilter: Bool {
        filterCtrl.isEmpty || filterCtrl == "Type Filter"
    }
}
