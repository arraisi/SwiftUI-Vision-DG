//
//  HistoryTabs.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/02/21.
//

import SwiftUI

struct HistoryTabs: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    
    @StateObject var historyVM = HistoryTransactionViewModel()
    
    @State private var filterShowed: Bool = true
    
    @State private var startDate = ""
    @State private var endDate = ""
    
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
                        Text(NSLocalizedString("Transaction Filter".localized(language), comment: ""))
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
        
    }
    
    var FilterView: some View {
        VStack {
            VStack(alignment: .center, spacing: 20){
                HStack {
                    Text(NSLocalizedString("Period of time".localized(language), comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("From".localized(language), comment: ""))
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
                        Text(NSLocalizedString("To".localized(language), comment: ""))
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
                    Text(NSLocalizedString("View Search Results".localized(language), comment: ""))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "#2334D0"))
                        .cornerRadius(15)
                })
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

struct HistoryTabs_Previews: PreviewProvider {
    static var previews: some View {
        HistoryTabs(cardNo: .constant(""), sourceNumber: .constant(""))
    }
}
