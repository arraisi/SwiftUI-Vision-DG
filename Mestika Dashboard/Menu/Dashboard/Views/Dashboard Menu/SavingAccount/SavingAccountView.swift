//
//  SavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 02/03/21.
//

import SwiftUI

struct SavingAccountView: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    @StateObject var productsSavingAccountVM = ProductsSavingAccountViewModel()
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @State var product: String = ""
    @State var planCode: String = ""
    @State var nextViewActive = false
    @State var nextPinViewActive = false
    
    @State var showFreezeMenu: Bool = false
    
    @State var showMaximumSavingAcc: Bool = false
    
    @State var balance: String = ""
    
    @State var description = ""
    
    var nextBtnDisabled: Bool {
        product.count == 0
    }
    
    var body: some View {
        LoadingView(isShowing: self.$productsSavingAccountVM.isLoading) {
            ZStack {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Saving Account".localized(language))
                                    .font(.custom("Montserrat-Bold", size: 28))
                                Text("Get the best savings only here".localized(language))
                                    .font(.custom("Montserrat-Bold", size: 14))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding([.top, .horizontal], 25)
                        
                        VStack {
                            HStack {
                                TextField("Choose a savings product".localized(language), text: $product)
                                    .onChange(of: product, perform: { value in
                                    })
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .frame(height: 50)
                                    .padding(.leading, 15)
                                    .disabled(true)
                                
                                Menu {
                                    ForEach(0..<productsSavingAccountVM.products.count, id: \.self) { i in
                                        Button(action: {
                                            print(productsSavingAccountVM.products[i])
                                            self.product = productsSavingAccountVM.products[i].productName
                                            self.planCode = productsSavingAccountVM.products[i].kodePlan
                                            self.description = productsSavingAccountVM.products[i].productDescription
                                        }) {
                                            
                                            if (productsSavingAccountVM.products.count < 1) {
                                                Text("Product Not Available")
                                                    .font(.custom("Montserrat-Regular", size: 12))
                                            } else {
                                                Text(productsSavingAccountVM.products[i].productName)
                                                    .font(.custom("Montserrat-Regular", size: 12))
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.right").padding()
                                }
                                
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                            .padding(.vertical, 5)
                            
                            Text(self.description)
                                .font(.custom("Montserrat-Regular", size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 15)
                            
                            Button(action: {
                                
                                if (self.profileVM.freezeAccount) {
                                    self.showFreezeMenu = true
                                } else {
                                    if (self.savingAccountVM.accounts.filter{ $0.categoryProduct == "S" }.count >= 3) {
                                        self.showMaximumSavingAcc = true
                                    } else {
                                        self.getProducDetails(planCode: self.planCode)
                                    }
                                }
        
                            }, label: {
                                Text("Opening a new savings account".localized(language))
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                                    .background(nextBtnDisabled ? Color(.lightGray) : Color("StaleBlue"))
                                    .cornerRadius(15)
                            })
                            .disabled(nextBtnDisabled)
                        }
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("White"), lineWidth: 1)
                        )
                        .shadow(color: Color(hex: "#3756DF").opacity(0.2), radius: 15, x: 0, y: 4)
                        .padding(25)
                        
                        VStack {
                            
                            HStack {
                                Text("Your savings account".localized(language))
                                    .font(.custom("Montserrat-SemiBold", size: 14))
                                Spacer()
                            }
                            .padding([.top, .horizontal])
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                ForEach(self.savingAccountVM.accounts, id: \.self) { item in
                                    
                                    HStack {
                                        RoundedIcon(imageName: "ic_saving_account")
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.productName ?? "")
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                            Text("No. Rekening: \(item.accountNumber)")
                                                .font(.custom("Montserrat-SemiBold", size: 10))
                                        }
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text(item.accountStatusDescription!)
                                                .font(.custom("Montserrat-SemiBold", size: 12))
                                                .foregroundColor(.white)
                                                .padding(.vertical, 10)
                                                .padding(.horizontal)
                                        }
                                        .background(Color("StaleBlue"))
                                        .cornerRadius(15)
                                    }
                                    .padding(.horizontal)
                                    
                                }
                                .listStyle(PlainListStyle())
                            }
                            .frame(height: 400)
                            
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        NavigationLink(destination: ConfirmationOfOpeningSavingAccountView(
                            product: self.$product,
                            codePlan: self.$planCode,
                            currency: self.balance,
                            minimumSaldo: self.productsSavingAccountVM.minimumSaldo ?? "0",
                            biayaAdministrasi: self.productsSavingAccountVM.biayaAdministrasi ?? "0",
                            minimumSetoranAwal: self.productsSavingAccountVM.minimumSetoranAwal ?? "0"
                        ), isActive: self.$nextViewActive) {EmptyView()}
                        
                        NavigationLink(destination: ConfirmationPinOfSavingAccountView(codePlan: planCode, product: product, deposit: .constant("0")), isActive: self.$nextPinViewActive) {EmptyView()}
                        
                    }
                })
                
                if (self.showMaximumSavingAcc || self.showFreezeMenu) {
                    ModalOverlay(tapAction: { withAnimation { } })
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarTitle("Saving Account".localized(language), displayMode: .inline)

        }
        .onAppear {
            self.getAccountBalance()
            self.checkFreezeAccount()
            self.productsSavingAccountVM.getProducts { (success) in
                
            }
            
            self.savingAccountVM.getAccounts { (success) in

            }
        }
        .popup(isPresented: $showMaximumSavingAcc, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            popupMaximumSavingAcc()
        }
        .popup(isPresented: $showFreezeMenu, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: false) {
            popupFreezeAccount()
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
            
            Button(action: {
                self.showFreezeMenu = false
            }) {
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
    
    // MARK: - POPUP CHECK CONNECTION INTERNET
    func popupMaximumSavingAcc() -> some View {
        VStack(alignment: .leading) {
            Image("ic_title_warning")
                .resizable()
                .frame(width: 101, height: 99)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("YOUR SUB ACCOUNT IS MAXIMAL AND CANNOT BE ADDED")
                .font(.custom("Montserrat-SemiBold", size: 13))
                .foregroundColor(Color(hex: "#232175"))
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)
            
            // MARK: change destination
            Button(
                action: {
                    self.showMaximumSavingAcc = false
                },
                label: {
                    Text("Back to Main Page")
                        .foregroundColor(.white)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
                .background(Color(hex: "#2334D0"))
                .cornerRadius(12)
                .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
    
    @ObservedObject var profileVM = ProfileViewModel()
    func getAccountBalance() {
        self.profileVM.getAccountBalance { success in
            if success {
                
                if self.profileVM.creditDebit == "D" {
                    self.balance = "0"
                } else {
                    self.balance = self.profileVM.balance
                }
                
            }
            
            if !success {
            }
        }
    }
    
    func getProducDetails(planCode: String) {
        self.productsSavingAccountVM.getProductsDetails(planCode: planCode) { result in
            
            print("\nif setoran awal ==  0 next to pin")
            print("result -> \(String(describing: result))")
            print("minimumSetoranAwal \(productsSavingAccountVM.minimumSetoranAwal ?? "0")")
            
            //                self.nextViewActive = true
            if result {
                if productsSavingAccountVM.minimumSetoranAwal == "" || productsSavingAccountVM.minimumSetoranAwal == "0" {
                    self.nextViewActive = true
                } else {
                    self.nextViewActive = true
                }
            } else {
                self.nextViewActive = true
            }
        }
    }
    
    func checkFreezeAccount() {
        self.profileVM.getAccountFreeze { sucess in }
    }
}

struct SavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SavingAccountView()
    }
}
