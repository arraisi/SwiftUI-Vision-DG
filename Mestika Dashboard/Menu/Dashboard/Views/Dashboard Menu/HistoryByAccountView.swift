//
//  HistoryByAccountView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 19/04/21.
//

import SwiftUI

struct HistoryByAccountView: View {
    
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
        .navigationBarTitle("History", displayMode: .inline)
        .onAppear {
            self.selectedSourceNumber = self.cardNo
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
                    VStack(alignment: .leading) {
                        Text(selectedSourceNumber)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    Spacer()
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
        self.historyVM.getList(cardNo: cardNo, sourceNumber: sourceNumber, dateFrom: startDate, dateTo: endDate) { (result) in
            print("PRINT ON VIEW HISTORY : GET LIST HISTORY STATUS -> \(result)")
        }
    }
}

struct HistoryByAccountView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryByAccountView(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
