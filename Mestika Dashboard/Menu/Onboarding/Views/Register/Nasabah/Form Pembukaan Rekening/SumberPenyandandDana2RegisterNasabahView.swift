//
// Created by Prima Jatnika on 28/11/20.
//

import SwiftUI

struct SumberPenyandandDana2RegisterNasabahView: View {
    /*
     Registrasi Environtment Object
     */
    @EnvironmentObject var registerData: RegistrasiModel
    
    // View variables
    let sumberPenyandangDana: [MasterModel] = load("sumberPenyandangDana.json")
    let hubunganOptions = ["Ayah", "Ibu", "Kaka", "Adik", "Saudara", "Teman"]
    let profesiPenyandandDanaOptions = ["Pegawai Swasta", "Pegawai Negeri", "Pegawai BUMN/BUMD", "Wirausaha"]
    @State var hubunganId : Int = 0
    @State var profesiPenyandangDanaId : Int = 0
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Color(hex: "#232175")
                    .frame(height: 380)
                Color(hex: "#F6F8FB")
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                AppBarLogo(light: false, onCancel: {})
                
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
                        
                        VStack{
                            // Title
                            Text("DATA PEMBUKAAN REKENING")
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(40)
                            
                            // Content
                            ZStack {
                                
                                // Forms
                                ZStack {
                                    
                                    VStack{
                                        LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                                    }
                                    .cornerRadius(25.0)
                                    .padding(.horizontal, 70)
                                    
                                    VStack{
                                        LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom)
                                    }
                                    .cornerRadius(25.0)
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
                                    .padding(.horizontal, 50)
                                    .padding(.top, 10)
                                    
                                    VStack {
                                        
                                        Spacer()
                                        
                                        // Sub title
                                        Text("Sumber Penyandang Dana")
                                                .font(.custom("Montserrat-SemiBold", size: 18))
                                                .foregroundColor(Color(hex: "#232175"))
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 30)

                                        // Forms input
                                        ZStack {
                                            cardForm
                                                .padding(.vertical, 20)
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Button
                                        NavigationLink(destination: SumberPendapatanLainnyaRegisterNasabahView().environmentObject(registerData), label:{
                                            
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 50)
                                            
                                        })
                                        .disabled(isValid())
                                        .frame(height: 50)
                                        .background(isValid() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                        
                                    }
                                    .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(25.0)
                                    .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 10, y: -2)
                                    .padding(.horizontal, 30)
                                    .padding(.top, 25)
                                }
                                
                            }
                            .padding(.bottom, 25)
                            
                        }
                    }
                }
                .KeyboardAwarePadding()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        
    }
    
    // MARK: - Form Group
    var cardForm: some View {
        
        VStack(alignment: .leading) {
            
            LabelTextField(value: $registerData.namaPenyandangDana, label: "Nama Penyandang Dana", placeHolder: "Nama"){ (changed) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                
                Text("Hubungan Dengan Anda")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Pilih hubungan", text: $registerData.hubunganPenyandangDana)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<hubunganOptions.count, id: \.self) { i in
                            Button(action: {
                                print(hubunganOptions[i])
                                registerData.hubunganPenyandangDana = hubunganOptions[i]
                            }) {
                                Text(hubunganOptions[i])
                                    .font(.custom("Montserrat-Regular", size: 10))
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.right").padding()
                    }
                    
                }
                .frame(height: 36)
                .font(Font.system(size: 14))
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                
                Text("Profesi Penyandang Dana")
                    .font(Font.system(size: 10))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Pilih profesi", text: $registerData.profesiPenyandangDana)
                        .font(.custom("Montserrat-Regular", size: 12))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .disabled(true)
                    
                    Menu {
                        ForEach(0..<profesiPenyandandDanaOptions.count, id: \.self) { i in
                            Button(action: {
                                print(profesiPenyandandDanaOptions[i])
                                registerData.profesiPenyandangDana = profesiPenyandandDanaOptions[i]
                            }) {
                                Text(profesiPenyandandDanaOptions[i])
                                    .font(.custom("Montserrat-Regular", size: 10))
                            }
                        }
                    } label: {
                        Image(systemName: "chevron.right").padding()
                    }
                    
                }
                .frame(height: 36)
                .font(Font.system(size: 14))
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            }
            .padding(.horizontal, 20)
            
        }
    }
    
    // MARK : - Check form is fill
    func isValid() -> Bool {
        if registerData.namaPenyandangDana == "" {
            return true
        }
        if registerData.hubunganPenyandangDana == "" {
            return true
        }
        if registerData.profesiPenyandangDana == "" {
            return true
        }
        return false
    }
}

struct SumberPenyandandDana2RegisterNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        SumberPenyandandDana2RegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
