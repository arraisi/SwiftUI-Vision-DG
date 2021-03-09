//
//  TransferRtgsDestination.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsDestination: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    // Environtment Object
    @EnvironmentObject var transferData: TransferOffUsModel
    
    // Variale Destination Type
    var _listDestinationType = ["Personal", "Company".localized(LocalizationService.shared.language), "Group".localized(LocalizationService.shared.language), "Foundation".localized(LocalizationService.shared.language)]
    @State private var destinationType: String = "Receiver Type".localized(LocalizationService.shared.language)
    
    // Variable Citizen Ship
    var _listCitizenShip = ["WNI", "WNA"]
    @State private var citizenShipCtrl: String = "Citizenship".localized(LocalizationService.shared.language)
    
    // Variable Province
    var _listProvince = ["Jawa Barat", "Jawa Timur", "Jawa Tengah"]
    @State private var provinceChoose: String = "Recipient Province".localized(LocalizationService.shared.language)
    
    // Variable City
    var _listCity = ["Bandung"]
    @State private var cityChoose: String = "Receiving City".localized(LocalizationService.shared.language)
    
    // Variable Notes
    @State private var addressCtrl: String = ""
    
    // Variable Route
    @State private var isRouteTransaction: Bool = false
    
    // Variable Disable
    @State private var disabledButton = true
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#F6F8FB")
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Text("Destination account".localized(language))
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                            Spacer()
                        }
                        
                        HStack {
                            Text("\(self.transferData.bankName) - \(self.transferData.destinationNumber)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.leading)
                            Spacer()
                        }
                    }
                    .padding(.vertical)
                    
                    VStack {
                        HStack {
                            Text("Nominal Transaction".localized(language))
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.leading)
                            Spacer()
                        }
                        
                        HStack(alignment: .top) {
                            Text("Rp")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            Text("\(self.transferData.amount.thousandSeparator())")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                }
                .background(Color(hex: "#232175"))
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        destinationCard
                        destinationTypeCard
                        citizenshipCard
                        
                        if (self.transferData.transactionType == "SKN") {
                            EmptyView()
                                .padding(.bottom, 30)
                        } else {
//                            provinceCard
//                            cityCard
                            addressCard
                        }
                        
                        Button(action: {
                            self.transferData.addressOfDestination = self.transferData.notes
                            self.isRouteTransaction = true
                        }, label: {
                            Text("CONFIRM TRANSFER".localized(language))
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disableForm)
                        .background(disableForm ? Color.gray : Color(hex: "#232175"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                })
            }
            
            NavigationLink(
                destination: TransferRtgsConfirmation().environmentObject(transferData),
                isActive: self.$isRouteTransaction,
                label: {
                    EmptyView()
                })
                .isDetailLink(false)
        }
        .navigationBarTitle("Transfer \(self.transferData.transactionType)", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.addressCtrl = self.transferData.notes
            self.isRouteTransaction = false
        }
    }
    
    var destinationCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Tn")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                .padding([.leading, .top, .bottom])
                
                TextField("Destination Name".localized(language), text: self.$transferData.destinationName, onEditingChanged: { changed in
//                    validateForm()
                })
                    .font(.subheadline)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var destinationTypeCard: some View {
        VStack {
            Menu {
                ForEach(self._listDestinationType, id: \.self) { data in
                    Button(action: {
                        self.destinationType = data
                        self.transferData.typeDestination = data
//                        validateForm()
                    }) {
                        Text(data)
                            .font(.custom("Montserrat-Regular", size: 12))
                    }
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(destinationType)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(destinationType == "Receiver Type".localized(LocalizationService.shared.language) ? .bold : .light)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var citizenshipCard: some View {
        VStack {
            Menu {
                ForEach(self._listCitizenShip, id: \.self) { data in
                    Button(action: {
                        self.citizenShipCtrl = data
                        self.transferData.citizenship = data
//                        validateForm()
                    }) {
                        Text(data)
                            .font(.custom("Montserrat-Regular", size: 12))
                    }
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(citizenShipCtrl)
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .fontWeight(citizenShipCtrl == "Citizenship".localized(LocalizationService.shared.language) ? .bold : .light)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var provinceCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(provinceChoose)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listProvince, id: \.self) { data in
                        Button(action: {
                            self.provinceChoose = data
                            self.transferData.provinceOfDestination = data
                        }) {
                            Text(data)
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                    }
                } label: {
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var cityCard: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(cityChoose)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.light)
                }
                .padding()
                
                Spacer()
                Menu {
                    ForEach(self._listCity, id: \.self) { data in
                        Button(action: {
                            self.cityChoose = data
                            self.transferData.cityOfDestination = data
                        }) {
                            Text(data)
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                    }
                } label: {
                    Image("ic_expand").padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
    }
    
    var addressCard: some View {
        VStack {
            HStack {
                Text("Recipient Address".localized(language))
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                MultilineTextField("Write the recipient's address".localized(language), text: self.$transferData.notes, onCommit: {
//                    validateForm()
                })
            }
            .padding(.horizontal, 20)
            .padding(.top, 5)
            .padding(.bottom, 25)
            
            
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .padding()
    }
    
    var disableForm: Bool {
        if (self.transferData.transactionType == "SKN") {
            
            if (            self.transferData.destinationName.isNotEmpty() && self.destinationType != "Receiver Type".localized(language) && self.citizenShipCtrl != "Citizenship".localized(language)) {
                return false
            }
            
        } else {
            
            if (self.transferData.destinationName.isNotEmpty() && self.destinationType != "Receiver Type".localized(language) && self.citizenShipCtrl != "Citizenship".localized(language) && self.transferData.notes.isNotEmpty()) {
                return false
            }
        }
        
        return true
    }
}

struct TransferRtgsDestination_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsDestination().environmentObject(TransferOffUsModel())
    }
}
