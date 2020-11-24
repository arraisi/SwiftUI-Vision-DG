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
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var location : String = ""
    @State var showingAddressModal = false
    @State var showingSuggestionNameModal = false
    
    @State var nameOnCard : String = ""
    @State var currentAddressOptionId = 1
    @State var currentAddress : Address = Address()
    
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
                AppBarLogo(light: true)
                    .padding(.top, 55)
                
                ScrollView {
                    Text("LENGKAPI DATA")
                        .multilineTextAlignment(.center)
                        .font(.custom("Montserrat-Bold", size: 26))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                    
                    nameCard
                    addressCard
                    
                    PushView(destination: FormCompletionReferalCodeView().environmentObject(RegistrasiModel())) {
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
                        
                        TextField("Masukkan Nama", text: $nameOnCard) { changed in
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
                selectedId: $currentAddressOptionId) { selected in
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
                    
                    TextField("Alamat", text: $currentAddress.address) { changed in
                    } onCommit: {
                    }
                    .font(Font.system(size: 14))
                    .frame(height: 36)
                    .disabled(currentAddressOptionId != 4)
                    
                    if currentAddressOptionId == 4 {
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
            
            LabelTextField(value: $currentAddress.rtRw, label: "", placeHolder: "RT/RW", disabled:currentAddressOptionId != 4 ) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $currentAddress.kelurahan, label: "", placeHolder: "Kelurahan", disabled:currentAddressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $currentAddress.kecamatan, label: "", placeHolder: "Kecamatan", disabled:currentAddressOptionId != 4) { (change) in
                
            } onCommit: {
                
            }
            
            LabelTextField(value: $currentAddress.kodePos, label: "", placeHolder: "Kode Pos", disabled:currentAddressOptionId != 4) { (change) in
                
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
                    currentAddress = cities[index]
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
                    nameOnCard = suggestions[index]
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
        switch currentAddressOptionId {
        case 1:
            currentAddress = Address(address: registerData.alamatKeluarga, city: registerData.kecamatanKeluarga, kodePos: registerData.kodePosKeluarga, kecamatan: registerData.kecamatanKeluarga, kelurahan: registerData.kelurahanKeluarga, rtRw: registerData.rtrw)
        case 2:
            currentAddress = Address(address: registerData.alamatKeluarga, city: registerData.kecamatanKeluarga, kodePos: registerData.kodePosKeluarga, kecamatan: registerData.kecamatanKeluarga, kelurahan: registerData.kelurahanKeluarga, rtRw: registerData.rtrw)
        case 3:
            currentAddress = Address(address: registerData.alamatPerusahaan, city: registerData.kecamatan, kodePos: registerData.kodePos, kecamatan: registerData.kecamatan, kelurahan: registerData.kelurahan, rtRw: registerData.rtrw)
        default:
            currentAddress = Address()
        }
    }
}

struct FormCompletionDataView_Previews: PreviewProvider {
    static var previews: some View {
        FormCompletionKartuATMView().environmentObject(RegistrasiModel())
    }
}
