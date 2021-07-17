//
// Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct ListStatementView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var eStatementVM = EStatementViewModel()
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @State var _listStatement: [EStatementModelElement] = []
    @State var listSourceNumber: [String] = []
    
    @State var selectedSourceNumber: String = ""
    
    let accountNumber: String
    
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    VStack(alignment: .center, spacing: 20){
                        HStack {
                            Text("Rekening Sumber".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                            Spacer()
                        }
                        
                        HStack {
                            Menu {
                                ForEach(0..<self.listSourceNumber.count) { index in
                                    Button(action: {
                                        self.selectedSourceNumber = self.listSourceNumber[index]
                                    }) {
                                        Text(self.listSourceNumber[index])
                                            .bold()
                                            .font(.custom("Montserrat-Regular", size: 12))
                                            .foregroundColor(.black)
                                    }
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(selectedSourceNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                Spacer()
                                
                                Image("ic_expand").padding()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                        
                        Button(action: {
                            self._listStatement.removeAll()
                            self.eStatementVM.getListEStatement(accountNumber: selectedSourceNumber) { (isSuccess) in
                                if isSuccess {
                                    self._listStatement = self.eStatementVM.listEStatement.data ?? []
                                }
                            }
                        }, label: {
                            Text("View Search Results".localized(language))
                                .font(.custom("Montserrat-SemiBold", size: 14))
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(Color(hex: selectedSourceNumber == "" ? "#CBD1D9" : "#232175"))
                                .cornerRadius(15)
                        })
                        .disabled(selectedSourceNumber == "" ? true : false)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    .padding()
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("E-Statement")
                            .font(.title)
                            .fontWeight(.bold)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        Text("Monthly financial reports".localized(language))
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    
                    if (_listStatement.isEmpty) {
                        
                    } else {
                        List {
                            ForEach(0..<_listStatement.count, id: \.self) { i in
                                HStack {
                                    HStack {
                                        Text(_listStatement[i].periode ?? "")
                                            .fontWeight(.semibold)
                                        Text(_listStatement[i].accountNumber ?? "")
                                            .fontWeight(.semibold)
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        self.eStatementVM.getFileEstatement(fileName: _listStatement[i].fileName!, accountNumber: selectedSourceNumber) { success in
                                            
                                            if success {
                                                self.showAlert = true
                                            }
                                            
                                        }
                                    }, label: {
                                        Image("ic_download")
                                    })
                                    
                                    
                                }.padding(.vertical, 5)
                            }
                        }.frame(height: 200)
                    }
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
            }

        }
        .navigationBarTitle("e-Statement", displayMode: .inline)
        .alert(isPresented: self.$showAlert) {
            return Alert(
                title: Text("MESSAGE"),
                message: Text("Download PDF Success"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear{
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    print(e.accountNumber)
                    
                    if (e.accountTypeDescription == "SAVING") {
                        self.listSourceNumber.append(e.accountNumber)
                    }
                }
            }
        }
    }
}

class ListStatementView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatementView(accountNumber: "20101084706")
    }
    
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ListStatementView(accountNumber: "80000000044"))
    }
}
