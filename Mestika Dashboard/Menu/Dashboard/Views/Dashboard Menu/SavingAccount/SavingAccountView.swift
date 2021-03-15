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
    
    var nextBtnDisabled: Bool {
        product.count == 0
    }
    
    var body: some View {
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
            
            VStack(spacing: 20) {
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
                                self.product = productsSavingAccountVM.products[i].name
                                self.planCode = productsSavingAccountVM.products[i].codePlan
                            }) {
                                Text(productsSavingAccountVM.products[i].name)
                                    .font(.custom("Montserrat-Regular", size: 12))
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.right").padding()
                    }
                    
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.vertical, 5)
                
                Button(action: {
                    self.getProducDetails(planCode: self.planCode)
                }, label: {
                    Text("Opening a new savings account".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
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
                
                List(self.savingAccountVM.accounts, id: \.self) { item in
                    
                    HStack {
                        RoundedIcon(imageName: "ic_saving_account")
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.accountName)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                            Text("No. Rekening: \(item.accountNumber)")
                                .font(.custom("Montserrat-SemiBold", size: 10))
                        }
                        
                        Spacer()
                    }
                    
                }
                .listStyle(PlainListStyle())
                
            }
            .padding(.leading, 10)
            
            Spacer()
            
            NavigationLink(destination: ConfirmationOfOpeningSavingAccountView(
                product: self.$product,
                currency: self.productsSavingAccountVM.currency,
                minimumSaldo: self.productsSavingAccountVM.minimumSaldo,
                biayaAdministrasi: self.productsSavingAccountVM.biayaAdministrasi,
                minimumSetoranAwal: self.productsSavingAccountVM.minimumSetoranAwal
            ), isActive: self.$nextViewActive) {EmptyView()}
            
            NavigationLink(destination: ConfirmationPinOfSavingAccountView(codePlan: planCode, product: product, deposit: .constant("0")), isActive: self.$nextPinViewActive) {EmptyView()}
        }
        .navigationBarTitle("Saving Account".localized(language), displayMode: .inline)
        .onAppear {
            self.productsSavingAccountVM.getProducts { (success) in
                
            }
            
            self.savingAccountVM.getAccounts { (success) in
                
            }
        }
    }
    
    func getProducDetails(planCode: String) {
        self.productsSavingAccountVM.getProductsDetails(planCode: planCode) { result in
            print("\nnext route saving account")
            print("\(String(describing: result))")
//            print("result -> \(result)")
            print("minimumSetoranAwal \(productsSavingAccountVM.minimumSetoranAwal)")
            if result {
                if productsSavingAccountVM.minimumSetoranAwal == "" || productsSavingAccountVM.minimumSetoranAwal == "0" {
                    self.nextPinViewActive = true
                } else {
                    self.nextViewActive = true
                }
            } else {
                self.nextPinViewActive = true
            }
        }
    }
}

struct SavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SavingAccountView()
    }
}
