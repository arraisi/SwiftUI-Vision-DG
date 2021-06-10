//
// Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct ListStatementView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @StateObject var eStatementVM = EStatementViewModel()
    
    @State var _listStatement: [EStatementModelElement] = []
    
    let accountNumber: String
    
    var body: some View {
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
                    //                    .font(.caption)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
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
                        
                        Button(action: {}, label: {
                            Image("ic_download")
                        })
                        
                        
                    }.padding(.vertical, 5)
                }
            }.frame(height: 200)
            
            Spacer()
        }
        .navigationBarTitle("e-Statement", displayMode: .inline)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .onAppear{
            self.eStatementVM.getListEStatement(accountNumber: self.accountNumber) { (isSuccess) in
                if isSuccess {
                    self._listStatement = self.eStatementVM.listEStatement.data ?? []
                }
            }
        }
    }
}

class ListStatementView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatementView(accountNumber: "80000000044")
    }
    
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ListStatementView(accountNumber: "80000000044"))
    }
}
