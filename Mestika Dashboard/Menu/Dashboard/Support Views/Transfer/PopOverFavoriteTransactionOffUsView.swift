//
//  PopOverFavoriteTransactionOffUsView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 12/02/21.
//

import SwiftUI

struct PopOverFavoriteTransactionOffUsView: View {
    
    @StateObject var favoritVM = FavoritViewModel()
    var transferData: TransferOffUsModel
    
    @Binding var show: Bool
    @Binding var showAlert: Bool
    
    @State var receivedName = ""
    
    var disableForm: Bool {
        receivedName.isEmpty
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Tambahkan ke Favorit?")
                        .font(.subheadline)
                        .fontWeight(.light)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Nama Kontrak Penerima")
                            .font(.subheadline)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    VStack {
                        TextField("Nama Kontak Penerima", text: self.$receivedName, onEditingChanged: { changed in
                            self.transferData.destinationName = self.receivedName
                        })
                        .disabled(true)
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
                            .font(.subheadline)
                            .fontWeight(.ultraLight)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    // Bank Form
                    HStack(alignment: VerticalAlignment.firstTextBaseline) {
                        
                        HStack {
                            Text("Bank")
                                .font(.callout)
                                .fontWeight(.light)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.trailing, 60)
                        
                        Spacer()
                        
                        MultilineTextField("Bank", text: .constant(transferData.bankName), onCommit: {
                            
                        })
                        .disabled(true)
                        .padding()
                        .font(.subheadline)
                        .background(Color(hex: "#F6F8FB"))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    
                    // No. Rekening Form
                    HStack(alignment: VerticalAlignment.firstTextBaseline) {
                        Text("No. Rekening")
                            .font(.callout)
                            .fontWeight(.light)
                        
                        Spacer()
                        
                        TextField("No. Rekening", text: .constant(transferData.destinationNumber), onEditingChanged: { changed in
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
                        
                        if (self.transferData.transactionType == "RTGS") {
                            self.favoritVM.transferRtgs(data: transferData) { result in
                                print("Berhasil simpan ke favorite")
                                self.show = false
                                self.showAlert = true
                            }
                        } else {
                            self.favoritVM.transferSkn(data: transferData) { result in
                                print("Berhasil simpan ke favorite")
                                self.show = false
                                self.showAlert = true
                            }
                        }
                        
                    }, label: {
                        Text("SIMPAN KE FAVORIT")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        
                    })
                    .disabled(disableForm)
                    .background(disableForm ? Color.gray : Color(hex: "#2334D0"))
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
            self.receivedName = self.transferData.destinationName
        }
    }
}

struct PopOverFavoriteTransactionOffUsView_Previews: PreviewProvider {
    static var previews: some View {
        PopOverFavoriteTransactionOffUsView(transferData: TransferOffUsModel(), show: .constant(false), showAlert: .constant(false))
    }
}
