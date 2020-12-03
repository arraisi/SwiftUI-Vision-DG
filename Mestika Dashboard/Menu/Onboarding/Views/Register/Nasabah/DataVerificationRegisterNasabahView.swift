//
//  FormVerificationRegisterDataNasabahScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI
import Indicators

struct DataVerificationRegisterNasabahView: View {
    
    /* Environtment & Bind Obj */
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var image: Image? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var nextRoute: Bool = false
    
    @ObservedObject private var userRegisterVM = UserRegistrationViewModel()
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false) {
                    
                }
                
                ScrollView {
                    
                    ZStack {
                        
                        VStack {
                            Color(hex: "#232175")
                                .frame(height: 380)
                            Color(hex: "#F6F8FB")
                                .cornerRadius(radius: 25.0, corners: .topLeft)
                                .cornerRadius(radius: 25.0, corners: .topRight)
                                .padding(.top, -30)
                        }
                        
                        VStack {
                            VStack(alignment: .leading) {
                                Image("ic_highfive")
                                    .resizable()
                                    .frame(width: 95, height: 95)
                                    .padding(.top, 40)
                                    .padding(.horizontal, 20)
                                
                                HStack {
                                    Text("Hi, ")
                                        .font(.custom("Montserrat-Bold", size: 24))
                                        .foregroundColor(Color(hex: "#232175"))
                                        .padding([.top, .bottom], 20)
                                        .padding(.leading, 20)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("\(registerData.email)")
                                        .font(.custom("Montserrat-Bold", size: 24))
                                        .foregroundColor(Color(hex: "#2334D0"))
                                        .padding([.top, .bottom], 20)
                                        .padding(.trailing, 20)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Anda telah memilih mendaftar jenis tabungan")
                                        .font(.custom("Montserrat-Regular", size: 12))
                                        .foregroundColor(Color(hex: "#707070"))
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 5)
                                        .padding(.horizontal, 20)
                                    
                                    Text("Deposit Tabungan.")
                                        .font(.custom("Montserrat-SemiBold", size: 12))
                                        .foregroundColor(Color(hex: "#2334D0"))
                                        .multilineTextAlignment(.leading)
                                        .padding(.horizontal, 20)
                                }
                                
                                Text("Sebelum melanjutkan proses pendaftaran, silahkan terlebih dahulu memverifikasi data yang telah Anda Isi.")
                                    .font(.custom("Montserrat-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#707070"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 15)
                                    .padding(.horizontal, 20)
                                
                                Divider()
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                                
                                Group {
                                    LabelTextField(value: $registerData.nik, label: "KTP", placeHolder: "KTP") { (Bool) in
                                        print("on edit")
                                    } onCommit: {
                                        print("on commit")
                                    }
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                                    .disabled(true)
                                    
                                    LabelTextField(value: $registerData.noTelepon, label: "No. Telepon", placeHolder: "No. Telepon") { (Bool) in
                                        print("on edit")
                                    } onCommit: {
                                        print("on commit")
                                    }
                                    .padding(.top, 10)
                                    .padding(.horizontal, 20)
                                    .disabled(true)
                                    
                                    LabelTextField(value: $registerData.email, label: "Email", placeHolder: "Email") { (Bool) in
                                        print("on edit")
                                    } onCommit: {
                                        print("on commit")
                                    }
                                    .padding(.top, 10)
                                    .padding(.horizontal, 20)
                                    .disabled(true)
                                    
                                    VStack {
                                        HStack {
                                            Text("Foto KTP")
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                self.registerData.fotoKTP
                                                    .resizable()
                                                    .frame(maxWidth: 80, maxHeight: 50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                        
                                        Divider()
                                    }
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                                    
                                    VStack {
                                        HStack {
                                            Text("Selfie")
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                self.registerData.fotoSelfie
                                                    .resizable()
                                                    .frame(maxWidth: 80, maxHeight: 50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                        Divider()
                                    }
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                                    
                                    VStack {
                                        HStack {
                                            Text("NPWP")
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#232175"))
                                                .fontWeight(.bold)
                                            Spacer()
                                            
                                            VStack {
                                                self.registerData.fotoNPWP
                                                    .resizable()
                                                    .frame(maxWidth: 80, maxHeight: 50)
                                                    .cornerRadius(8)
                                            }
                                            .frame(maxWidth: 80, minHeight: 50, maxHeight: 50)
                                        }
                                        Divider()
                                    }
                                    .padding([.top, .bottom], 20)
                                    .padding(.horizontal, 20)
                                    
                                    Group {
                                        
                                        Text("Tujuan Pembukaan Rekening")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Tujuan Pembukaan Rekening", text: $registerData.tujuanPembukaan)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: TujuanPembukaanRekeningRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        
                                        Text("Sumber Dana")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Sumber Dana", text: $registerData.sumberDana)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: SumberDanaRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        
                                        
                                        Text("Perkiraan Penarikan")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Perkiraan Penarikan", text: $registerData.perkiraanPenarikan)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: PerkiraanPenarikanDanaRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                    }
                                    
                                    Group {
                                        Text("Besar Perkiraan Penarikan")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Besar Perkiraan Penarikan", text: $registerData.besarPerkiraanPenarikan)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: BesarPerkiraanPenarikanDanaRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        
                                        Text("Perkiraan Setoran")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Perkiraan Setoran", text: $registerData.perkiraanSetoran)
                                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: PerkiraanSetoranRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        
                                        Text("Besar Perkiraan Setoran")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Besar Perkiraan Setoran", text: $registerData.besarPerkiraanPenarikan)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: BesarPerkiraanSetoranRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        
                                        Text("Pekerjaan")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal, 20)
                                        
                                        HStack {
                                            TextField("Pekerjaan", text: $registerData.pekerjaan)
                                                .disabled(true)
                                            
                                            Divider()
                                                .frame(height: 30)
                                            
                                            NavigationLink(destination: PekerjaanRegisterNasabahView(editMode: .active).environmentObject(registerData)) {
                                                Text("Edit").foregroundColor(.blue)
                                            }
                                        }
                                        .frame(height: 20)
                                        .font(.subheadline)
                                        .padding()
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(15)
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 20)
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 30)
                        }
                        .padding(.vertical, 25)
                        
                    }
                }
                
                VStack {
                    Button(action: {
                        
                        //                        saveUserToCoreData()
                        saveUserToDb()
                        
                    }, label: {
                        Text("Submit Data")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                            .foregroundColor(.white)
                    })
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 80)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(self.userRegisterVM.isLoading)
                    
                    NavigationLink(
                        destination: SuccessRegisterNasabahScreen().environmentObject(registerData),
                        isActive: self.$nextRoute,
                        label: {EmptyView()}
                    )
                }
                //                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarItems(
            trailing: LoadingIndicator(style: .medium, animate: .constant(self.userRegisterVM.isLoading))
                .configure {
                    $0.color = .white
                })
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("\(self.userRegisterVM.message)"),
                dismissButton: .default(Text("Oke")))
        }
    }
    
    /* Function Retrive Image */
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            return image
        }
        
        return nil
    }
    
    /* Save User To Core Data */
    func saveUserToCoreData()  {
        
        if (user.isEmpty) {
            print("------SAVE TO CORE DATA-------")
            
            let data = User(context: managedObjectContext)
            data.deviceId = UIDevice.current.identifierForVendor?.uuidString
            
            data.nik = self.registerData.nik
            data.email = self.registerData.email
            data.phone = self.registerData.noTelepon
            data.pin = self.registerData.pin
            data.password = self.registerData.password
            data.firstName = "Stevia"
            data.lastName = "R"
            data.email = self.registerData.email
            
            UserDefaults.standard.set("false", forKey: "isFirstLogin")
            UserDefaults.standard.set("true", forKey: "isSchedule")
            
            nextRoute = true
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Error saving managed object context: \(error)")
            }
        } else {
            
            print("GAGAL MENDAFTAR")
            showingAlert = true
        }
        
    }
    
    /* Save User To DB */
    func saveUserToDb() {
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                print("SUCCESS")
                nextRoute = true
            }
            
            if !success {
                print("GAGAL")
                self.showingAlert = true
            }
        }
    }
}

struct FormVerificationRegisterDataNasabahScreen_Previews: PreviewProvider {
    static var previews: some View {
        DataVerificationRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
