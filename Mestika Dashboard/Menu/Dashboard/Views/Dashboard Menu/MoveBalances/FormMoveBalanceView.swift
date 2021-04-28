//
//  FormMoveBalanceView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 27/04/21.
//

import SwiftUI

struct FormMoveBalanceView: View {
    
    // Environtment Object
    @EnvironmentObject var transactionData: MoveBalancesModel
    
    @State private var amountCtrl: String = ""
    @State private var selectedCalendar: String = "Now"
    @State private var frekuensiSelectedCtrl = "Select Transaction Frekuensi"
    @State private var notesCtrl: String = ""
    
    @State private var saldoAktif: String = "0"
    @State private var amountDbl: Double = 0
    
    // Variable List
    private var _listVoucher = ["Sekali Pengiriman"]
    
    // Variable Date
    @State var date = Date()
    let now = Date()
    
    // Routing
    @State private var nextRouting: Bool = false
    
    var body: some View {
        ZStack {
            
            // Route Link
            NavigationLink(
                destination: MoveBalanceConfirmationView().environmentObject(transactionData),
                isActive: self.$nextRouting,
                label: {}
            )
            
            // bg color
            Color(hex: "#F4F7FA")
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                // information destination
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Dari")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#8790CD"))
                                .padding(.bottom, 2)
                            
                            Text("Rekening Utama")
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Text("-->")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Ke")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#8790CD"))
                                .padding(.bottom, 2)
                            
                            Text("\(self.transactionData.destinationName)")
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding([.vertical, .horizontal], 20)
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                .background(Color(hex: "#2334D0"))
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                .padding(.vertical, 20)
                
                // nominal input
                VStack(alignment: .leading) {
                    Text("Jumlah Besaran (Rp)")
                        .fontWeight(.bold)
                    
                    HStack(alignment: .top) {
                        Text("Rp.")
                            .foregroundColor(Color(hex: "#232175"))
                            .fontWeight(.bold)
                        
                        TextField("0", text: self.$amountCtrl, onEditingChanged: {_ in })
                            .onReceive(amountCtrl.publisher.collect()) {
                                let amountString = String($0.prefix(13))
                                let cleanAmount = amountString.replacingOccurrences(of: ".", with: "")
                                self.amountCtrl = cleanAmount.thousandSeparator()
                                
                                self.amountDbl = Double(cleanAmount) ?? 0
                                
                                if (self.amountDbl > Double(self.saldoAktif)!) {
                                    self.amountCtrl = self.saldoAktif.thousandSeparator()
                                }
                            }
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.system(size: 35, weight: .bold, design: .default))
                            .keyboardType(.numberPad)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                    
                    Divider()
                    
                    HStack {
                        Text("Saldo aktif Tabungan-Ku")
                            .font(.system(size: 12))
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            Text("Rp")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                            
                            Text("\(self.saldoAktif.thousandSeparator())")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color(hex: "#232175"))
                    }
                }
                .padding([.vertical, .horizontal], 20)
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                .padding(.bottom, 20)
                
                // calendar
                VStack {
                    HStack {
                        
                        DatePicker(selection: selectedDate, in: dateClosedRange, displayedComponents: .date) {
                            Text(self.selectedCalendar)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#232175"))
                                .fontWeight(.semibold)
                        }
                        
                    }
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                .padding(.bottom, 20)
                
                // frekuensi
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(frekuensiSelectedCtrl)
                                .font(.subheadline)
                                .foregroundColor(frekuensiSelectedCtrl == "Select Transaction Frekuensi" ? .gray : .black)
                                .fontWeight(.light)
                        }
                        .padding()
                        
                        Spacer()
                        Menu {
                            ForEach(self._listVoucher, id: \.self) { data in
                                Button(action: {
                                    self.frekuensiSelectedCtrl = data
                                    self.transactionData.transactionFrequency = data
                                }) {
                                    Text(data)
                                        .font(.system(size: 12, weight: .bold))
                                }
                            }
                        } label: {
                            Image("ic_expand").padding()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                .padding(.bottom, 20)
                
                // notes
                VStack {
                    HStack {
                        Text("Catatan")
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 25)
                    
                    VStack {
                        MultilineTextField("Tulis keterangan transaksi disini", text: self.$notesCtrl, onCommit: {
                            self.transactionData.notes = self.notesCtrl
                        })
                        .onReceive(notesCtrl.publisher.collect()) {
                            self.notesCtrl = String($0.prefix(40))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .padding(.bottom, 25)
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.gray.opacity(0.3), radius: 10)
                
            })
            .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
            
            VStack {
                Spacer()
                Button(action: {
                    
                    self.transactionData.transactionDate = dateFormatter.string(from: self.date)
                    
                    if (notesCtrl.isEmpty) {
                        self.transactionData.notes = "-"
                    }
                    
                    self.transactionData.amount = self.amountCtrl
                    
                    self.nextRouting = true
                    
                }, label: {
                    Text("KONFIRMASI TRANSAKSI")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                })
                .disabled(disableForm)
                .background(disableForm ? Color.gray : Color(hex: "#232175"))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .onAppear {
            self.saldoAktif = self.transactionData.mainBalance
        }
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var selectedDate: Binding<Date> {
        Binding<Date>(get: { self.date}, set : {
            self.date = $0
            self.setDateString()
        })
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        return min...max
    }
    
    func setDateString() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if (formatter.string(from: self.now) == formatter.string(from: self.date)) {
            self.selectedCalendar = "Now"
        } else {
            self.selectedCalendar = "Next"
        }
        
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "in_ID")
        return formatter
    }
    
    var disableForm: Bool {
        if (amountCtrl.isNotEmpty() && frekuensiSelectedCtrl != "Select Transaction Frekuensi") {
            return false
        }
        return true
    }
}

struct FormMoveBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        FormMoveBalanceView().environmentObject(MoveBalancesModel())
    }
}
