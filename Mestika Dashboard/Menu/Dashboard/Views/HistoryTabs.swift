//
//  HistoryTabs.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/02/21.
//

import SwiftUI

struct HistoryTabs: View {
    
    @State private var timeLogout = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var showAlertTimeout: Bool = false
    
    @EnvironmentObject var appState: AppState
    
    @ObservedObject private var authVM = AuthViewModel()
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @StateObject var historyVM = HistoryTransactionViewModel()
    @StateObject var savingAccountVM = SavingAccountViewModel()
    
    @State var listSourceNumber: [String] = []
    @State var listCardNumber: [String] = []
    
    @State private var filterShowed: Bool = true
    
    @State private var startDate = ""
    @State private var endDate = ""
    @State var selectedSourceNumber: String = ""
    @State var selectedCardNumber: String = ""
    
    @State private var dateFrom = Date()
    @State private var dateTo = Date()
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        return min...max
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    
    @Binding var cardNo: String
    @Binding var sourceNumber: String
    
    var body: some View {
        
        let tap = TapGesture()
            .onEnded { _ in
                self.timeLogout = 300
                print("View tapped!")
            }
        
        ZStack {
            if filterShowed {
                
                FilterView
                
            } else {
                
                VStack {
                    
                    Button(action: {
                        self.filterShowed = true
                    }, label: {
                        Text("Transaction Filter".localized(language))
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    })
                    .padding()
                    
                    HistoryTransactionList(histories: historyVM.histories)
                    
                }
            }
            
        }
        .gesture(tap)
        .onReceive(timer) { time in
            print(self.timeLogout)
            if self.timeLogout > 0 {
                self.timeLogout -= 1
            }
            
            if self.timeLogout < 1 {
                showAlertTimeout = true
            }
        }
        .alert(isPresented: $showAlertTimeout) {
            return Alert(title: Text("Session Expired"), message: Text("You have to re-login"), dismissButton: .default(Text("OK".localized(language)), action: {
                self.authVM.postLogout { success in
                    if success {
                        print("SUCCESS LOGOUT")
                        DispatchQueue.main.async {
                            self.appState.moveToWelcomeView = true
                        }
                    }
                }
            }))
        }
        .onAppear {
            self.savingAccountVM.getAccounts { (success) in
                self.savingAccountVM.accounts.forEach { e in
                    print(e.accountNumber)
                    
                    if (e.accountTypeDescription == "SAVING") {
                        self.listSourceNumber.append(e.accountNumber)
                        self.listCardNumber.append(e.cardNumber)
                    }
                }
            }
        }
        
    }
    
    var FilterView: some View {
        VStack {
            VStack(alignment: .center, spacing: 20){
                HStack {
                    Text("Period of time".localized(language))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                    Spacer()
                }
                
                HStack {
                    Menu {
                        ForEach(0..<self.listSourceNumber.count) { index in
                            Button(action: {
                                self.selectedSourceNumber = self.listSourceNumber[index]
                                self.selectedCardNumber = self.listCardNumber[index]
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
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("From".localized(language))
                        DatePicker(
                            "From",
                            selection: $dateFrom,
                            in: dateClosedRange,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("To".localized(language))
                        DatePicker(
                            "To",
                            selection: $dateTo,
                            in: dateFrom...Date(),
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                    }
                }
                .font(.custom("Montserrat-Regular", size: 14))
                
                Button(action: {
                    startDate = dateFormatter.string(from: dateFrom)
                    endDate = dateFormatter.string(from: dateTo)
                    self.loadHistory()
                    self.filterShowed = false
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
    }
    
    func loadHistory() {
        self.historyVM.getList(cardNo: selectedCardNumber, sourceNumber: selectedSourceNumber, dateFrom: startDate, dateTo: endDate) { (result) in
            print("PRINT ON VIEW HISTORY : GET LIST HISTORY STATUS -> \(result)")
        }
    }
}

struct HistoryTabs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTabs(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
