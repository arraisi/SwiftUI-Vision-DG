//
//  SavingAccountView.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 02/03/21.
//

import SwiftUI

struct SavingAccountView: View {
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    let savingProducts:[String] = ["Tabunganku", "Tabungan Mestika", "Tabungan Setia", "Tabungan SimPel"]
    let mySavingProducts:[String] = ["Tabunganku", "Tabungan Mestika"]
    @State var product: String = ""
    
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
                        ForEach(0..<savingProducts.count, id: \.self) { i in
                            Button(action: {
                                print(savingProducts[i])
                                product = savingProducts[i]
                            }) {
                                Text(savingProducts[i])
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
                
                NavigationLink(destination: ConfirmationOfOpeningSavingAccountView(), label: {
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
                
                List(self.mySavingProducts, id: \.self) { item in
                    
                    HStack {
                        RoundedIcon(imageName: "ic_saving_account")
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item)
                                .font(.custom("Montserrat-SemiBold", size: 14))
                            Text("No. Rekening: 1201020201")
                                .font(.custom("Montserrat-SemiBold", size: 10))
                        }
                        
                        Spacer()
                    }
                    
                }
                .listStyle(PlainListStyle())
                
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .navigationBarTitle("Saving Account")
    }
}

struct SavingAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SavingAccountView()
    }
}