//
//  TransferRtgsDestination.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 08/02/21.
//

import SwiftUI

struct TransferRtgsDestination: View {
    
    // Environtment Object
    @EnvironmentObject var transferData: TransferOffUsModel
    
    // Variale Destination Type
    var _listDestinationType = ["Personal", "Perusahaan", "Kelompok", "Yayasan"]
    @State private var destinationType: String = "Tipe Penerima"
    
    // Variable Citizen Ship
    var _listCitizenShip = ["WNI", "WNA"]
    @State private var citizenShipCtrl: String = "Kewarganegaraan"
    
    // Variable Province
    var _listProvince = ["Jawa Barat", "Jawa Timur", "Jawa Tengah"]
    @State private var provinceChoose: String = "Provinsi Penerima"
    
    // Variable City
    var _listCity = ["Bandung"]
    @State private var cityChoose: String = "Kota Penerima"
    
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
                            Text("Rekening Tujuan")
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
                            Text("Nominal Transaksi")
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
                            self.transferData.addressOfDestination = self.addressCtrl
                            self.isRouteTransaction = true
                        }, label: {
                            Text("KONFIRMASI TRANSFER")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        })
                        .disabled(disabledButton)
                        .background(disabledButton ? Color.gray : Color(hex: "#232175"))
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
        }
        .navigationBarTitle("Transfer \(self.transferData.transactionType)", displayMode: .inline)
        .onTapGesture() {
            UIApplication.shared.endEditing()
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
                
                TextField("Nama Tujuan", text: self.$transferData.destinationName, onEditingChanged: { changed in
                    validateForm()
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
                        validateForm()
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
                            .fontWeight(.light)
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
                        validateForm()
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
                            .fontWeight(.light)
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
                Text("Alamat Penerima")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.top, 25)
            
            VStack {
                MultilineTextField("Tulis alamat penerima", text: self.$addressCtrl, onCommit: {
                    validateForm()
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
    
    func validateForm() {
        if (self.transferData.transactionType == "SKN") {
            if (self.transferData.destinationName.isNotEmpty() && self.destinationType != "Tipe Penerima" && self.citizenShipCtrl != "Kewarganegaraan") {
                disabledButton = false
            } else {
                disabledButton = true
            }
        } else {
            if (self.transferData.destinationName.isNotEmpty() && self.destinationType != "Tipe Penerima" && self.citizenShipCtrl != "Kewarganegaraan" && self.addressCtrl.isNotEmpty()) {
                disabledButton = false
            } else {
                disabledButton = true
            }
        }
    }
}

struct TransferRtgsDestination_Previews: PreviewProvider {
    static var previews: some View {
        TransferRtgsDestination().environmentObject(TransferOffUsModel())
    }
}
