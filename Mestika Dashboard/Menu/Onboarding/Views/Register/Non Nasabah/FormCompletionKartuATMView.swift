//
//  CompletionDataView.swift
//  Mestika Dashboard
//
//  Created by Andri Ferinata on 23/11/20.
//

import SwiftUI
import NavigationStack

struct FormCompletionKartuATMView: View {
    
    /* Environtment Object */
    @EnvironmentObject var atmData: AddProductATM
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var location : String = ""
    @State var showingAddressModal = false
    @State var showingSuggestionNameModal = false
    
//    @State var nameOnCard : String = ""
//    @State var currentAddress : Address = Address()
    
    //Dummy data
    var currentUser = UserDetails(firstName: "", lastName: "", productName: "", phone: "", email: "", nik: "", imageKtp: nil, imageSelfie: nil, hasNoNpwp: false, imageNpwp: nil, purposeOfAccountOpening: "", sourcOfFunds: "", monthlyWithdrawalFrequency: "", monthlyWithdrawalAmount: "", monthlyDepositFrequency: "", monthlyDepositAmount: "", occupation: "", position: "", companyName: "", companyAddress: "", companyKecamatan: "", companyKelurahan: "", companyPostalCode: "", companyPhoneNumber: "", companyBusinessField: "", annualGrossIncome: "", hasOtherSourceOfIncome: "", otherSourceOfIncome: "", relativeRelationship: "", relativesName: false, relativesAddress: "Jl XDam 1", relativesPostalCode: "50423", relativesKelurahan: "Karang Mekar", relativesPhoneNumber: "", funderName: "", funderRelation: "", funderOccupation: "", isWni: true, isAgreeTNC: false, isAgreetoShare: false, isAddressEqualToDukcapil: false, correspondenceAddress: "BPC D2", correspondenceRt: "01", correspondenceRw: "02", correspondenceKelurahan: "Cibeber", correspondenceKecamatan: "Cimahi Selatan", correspondencePostalCode: "40151")
    
    let addressOptions: [MasterModel] = [
        MasterModel(id: 1, name: "Alamat Sesuai KTP"),
        MasterModel(id: 2, name: "Alamat Surat Menyurat"),
        MasterModel(id: 3, name: "Alamat Perusahaan"),
        MasterModel(id: 4, name: "Alamat Lainnya"),
    ]
    
    let cities:[Address] = [
        .init(city: "Jakarta Selatan", kodePos: "14012", kecamatan: "Jakarta Selatan", kelurahan: "Selatan"),
        .init(city: "Jakarta Barat", kodePos: "14012", kecamatan: "Jakarta Barat", kelurahan: "Barat"),
        .init(city: "Jakarta Timur", kodePos: "14012", kecamatan: "Jakarta Timur", kelurahan: "Timur"),
        .init(city: "Jakarta Utara", kodePos: "14012", kecamatan: "Jakarta Utara", kelurahan: "Utara")
    ]
    
    let suggestions:[String] = [
        "ANDRI FERINATA",
        "A. FERINATA",
        "ANDRI F"
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("bg_blue")
                    .resizable()
                    .scaledToFill()
            }
            VStack {
                AppBarLogo(light: false, onCancel:{})
                
                ScrollView {
                    Text("LENGKAPI DATA")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    
                    nameCard
                    addressCard
                    
                    NavigationLink(destination: FormCompletionReferalCodeView().environmentObject(atmData)) {
                        Text("MASUKKAN DATA")
                            .foregroundColor(Color("DarkStaleBlue"))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                    .padding(.vertical, 30)
                }
            }
        }
        .introspectNavigationController { navigationController in
            navigationController.hidesBarsOnSwipe = true
        }
        .edgesIgnoringSafeArea(.top)
//        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarHidden(true)
        .onTapGesture() {
            UIApplication.shared.endEditing()
        }
        .popup(isPresented: $showingSuggestionNameModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomSuggestionNameFloater()
        }
        .popup(isPresented: $showingAddressModal, type: .default, position: .bottom, animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
            createBottomAddressFloater()
        }
        .onAppear(){
            fetchAddressOption()
        }
    }
    
    var nameCard: some View {
        ZStack {
            VStack {
                Text("Nama Pada Kartu ATM")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                Text("Nama ini akan dicetak pada kartu ATM baru Anda")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat", size: 10))
                    .foregroundColor(Color("DarkStaleBlue"))
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Group {
                    
                    Text("")
                        .font(Font.system(size: 10))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#707070"))
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        
                        TextField("Masukkan Nama", text: $atmData.atmName) { changed in
                            if changed {
                                showingSuggestionNameModal.toggle()
                            }
                        } onCommit: {
                        }
                        .font(Font.system(size: 14))
                        .frame(height: 36)
                        
//                        Button(action:{
//                            showingSuggestionNameModal.toggle()
//                        }, label: {
//                            Image(systemName: "location.viewfinder")
//                                .font(Font.system(size: 20))
//                                .foregroundColor(Color(hex: "#707070"))
//                        })
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                }
            }
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
    
    var addressCard: some View {
        VStack {
            Text("Alamat Pengiriman")
                .multilineTextAlignment(.center)
                .font(.custom("Montserrat-Bold", size: 18))
                .foregroundColor(Color("DarkStaleBlue"))
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
            
            RadioButtonGroup(
                items: addressOptions,
                selectedId: $atmData.addressOptionId) { selected in
                fetchAddressOption()
            }
            .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            
            VStack { Divider() }.padding(.horizontal, 20)
            
            formAddress
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
        .padding(.top, 20)
    }
    
    var formAddress: some View {
        VStack(alignment: .leading) {
            
            Group {
                
                Text("")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    
                    TextField("Alamat", text: $atmData.atmAddressInput) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(atmData.addressOptionId != 4)
                    
                    if atmData.addressOptionId == 4 {
                        Button(action:{
                            showingAddressModal.toggle()
                        }, label: {
                            Image(systemName: "location.viewfinder")
                                .font(Font.system(size: 20))
                                .foregroundColor(Color(hex: "#707070"))
                        })
                    }
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            
            LabelTextField(value: $atmData.atmAddressrtRwInput, label: "", placeHolder: "RT/RW", disabled:atmData.addressOptionId != 4 ) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskelurahanInput, label: "", placeHolder: "Kelurahan", disabled:atmData.addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresskecamatanInput, label: "", placeHolder: "Kecamatan", disabled:atmData.addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $atmData.atmAddresspostalCodeInput, label: "", placeHolder: "Kode Pos", disabled:atmData.addressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
    }
    
    // MARK: -Fuction for Create Bottom Floater (Modal)
    
    func createBottomAddressFloater() -> some View {
        VStack {
            HStack {
                Text("Alamat")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            HStack {
                
                TextField("Alamat Perusahaan", text: $location)
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                
                Button(action:{
                    print("find location")
                }, label: {
                    Image(systemName: "location.viewfinder")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(hex: "#707070"))
                })
                
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            List(0...cities.count-1, id: \.self) {index in
                
                HStack {
                    Text(cities[index].city)
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(cities[index])
                    atmData.atmAddressInput = cities[index].address
                    atmData.atmAddresspostalCodeInput = cities[index].kodePos
                    atmData.atmAddresskecamatanInput = cities[index].kecamatan
                    atmData.atmAddresskelurahanInput = cities[index].kelurahan
                    atmData.atmAddressrtRwInput = cities[index].rtRw
                    
                    self.showingAddressModal.toggle()
                })
                
            }
            .background(Color.white)
            .padding(.vertical)
            .frame(height: 150)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func createBottomSuggestionNameFloater() -> some View {
        VStack {
            HStack {
                Text("Nama Kartu")
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                    .foregroundColor(Color(hex: "#232175"))
                Spacer()
            }
            
            List(0...suggestions.count-1, id: \.self) {index in
                
                HStack {
                    Text(suggestions[index])
                        .font(Font.system(size: 14))
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    print(suggestions[index])
                    atmData.atmName = suggestions[index]
                    self.showingSuggestionNameModal.toggle()
                })
                
            }
            .background(Color.white)
//            .padding(.vertical)
            .frame(height: 200)
            .cornerRadius(20)
            
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
    
    func fetchAddressOption() {
        switch atmData.addressOptionId {
        case 1:
            atmData.atmAddressInput = currentUser.relativesAddress
            atmData.atmAddresspostalCodeInput = currentUser.relativesPostalCode
            atmData.atmAddresskecamatanInput = currentUser.relativesKelurahan
            atmData.atmAddresskelurahanInput = currentUser.relativesKelurahan
            atmData.atmAddressrtRwInput = ""
        case 2:
            atmData.atmAddressInput = currentUser.correspondenceAddress
            atmData.atmAddresspostalCodeInput = currentUser.correspondencePostalCode
            atmData.atmAddresskecamatanInput = currentUser.correspondenceKecamatan
            atmData.atmAddresskelurahanInput = currentUser.correspondenceKelurahan
            atmData.atmAddressrtRwInput = "\(currentUser.correspondenceRt)\\\(currentUser.correspondenceRw)"
//            currentAddress = Address(address: currentUser.correspondenceAddress, city: currentUser.correspondenceKecamatan, kodePos: currentUser.correspondencePostalCode, kecamatan: currentUser.correspondenceKecamatan, kelurahan: currentUser.correspondenceKelurahan, rtRw: "\(currentUser.correspondenceRt)\\\(currentUser.correspondenceRw)")
        case 3:
            atmData.atmAddressInput = currentUser.companyAddress
            atmData.atmAddresspostalCodeInput = currentUser.companyPostalCode
            atmData.atmAddresskecamatanInput = currentUser.companyKecamatan
            atmData.atmAddresskelurahanInput = currentUser.companyKelurahan
            atmData.atmAddressrtRwInput = ""
//            currentAddress = Address(address: currentUser.companyAddress, city: currentUser.companyKecamatan, kodePos: currentUser.companyPostalCode, kecamatan: currentUser.companyKecamatan, kelurahan: currentUser.companyKelurahan, rtRw: "")
        default:
            atmData.atmAddressInput = ""
            atmData.atmAddresspostalCodeInput = ""
            atmData.atmAddresskecamatanInput = ""
            atmData.atmAddresskelurahanInput = ""
            atmData.atmAddressrtRwInput = ""
//            currentAddress = Address()
        }
    }
}

struct FormCompletionDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionKartuATMView().environmentObject(AddProductATM())
    }
}