//
// Created by Prima Jatnika on 03/11/20.
//

import SwiftUI

struct ListStatementView: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @State var _listStatement = [
        Statement(id: 1, bulan: "Agustus", tahun: "2020"),
        Statement(id: 2, bulan: "September", tahun: "2020"),
        Statement(id: 3, bulan: "Oktober", tahun: "2020"),
        Statement(id: 4, bulan: "November", tahun: "2020"),
    ]
    
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
                    .font(.caption)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            Divider()
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
            
            List {
                ForEach(_listStatement) { data in
                    HStack {
                        HStack {
                            Text(data.bulan)
                                .fontWeight(.semibold)
                            Text(data.tahun)
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
    }
}

class ListStatementView_Previews: PreviewProvider {
    static var previews: some View {
        ListStatementView()
    }

    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ListStatementView())
    }
}
