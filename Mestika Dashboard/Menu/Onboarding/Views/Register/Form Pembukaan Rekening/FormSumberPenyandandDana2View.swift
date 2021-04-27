//
//  FormSumberPenyandandDana2View.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/11/20.
//

import SwiftUI

struct FormSumberPenyandandDana2View: View {
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    /* Registrasi Environtment Object */
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    /* Variable for Swipe Gesture to Back */
    @State var showingAlert: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    
    // Routing variables
    @State var editMode: EditMode = .inactive
    
    @State var routeToSumberPendapatanLainnya: Bool = false
    @State var routeToPenghasilanKotor: Bool = false
    
    // View variables
    let sumberPenyandangDana: [MasterModel] = load("sumberPenyandangDana.json")
    let hubunganOptions = ["Ayah", "Ibu", "Kakak", "Adik", "Saudara", "Teman"]
    let profesiPenyandandDanaOptions = [
        "Pejabat Pemerintah",
        "Parpol",
        "Pegawai Swasta",
        "Wirausaha",
        "Pegawai Negeri",
        "Pegawai BUMN/ BUMD",
        "Ibu Rumah Tangga",
        "Polisi",
        "Militer",
        "Pensiunan",
        "Notaris",
        "Pengacara",
        "Guru/Dosen",
        "Dokter",
        "Pimpinan Keagamaan",
        "Advokat",
        "Kurator",
        "Konsultan Keuangan",
        "Konsultan Pajak",
        "Konsultan Lainnya",
        "Buruh",
        "Pembantu Rumah Tangga",
        "Akuntan",
        "Pelajar/Mahasiswa",
        "Karyawan Bank Mestika",
        "Hakim",
        "Jaksa",
        "Auditor",
        "Petani/Nelayan/Peternak",
        "Wiraswasta"
    ]
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
                            Text("OPENING ACCOUNT DATA".localized(language))
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
                                        Text("Funding Resources".localized(language))
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
                                        
                                        NavigationLink(destination: SumberPendapatanLainnyaView().environmentObject(registerData),
                                                       isActive: $routeToSumberPendapatanLainnya,
                                                       label: {
                                                        EmptyView()
                                                       })
                                        
                                        NavigationLink(destination: PenghasilanKotorView().environmentObject(registerData),
                                                       isActive: $routeToPenghasilanKotor,
                                                       label: {
                                                        EmptyView()
                                                       })
                                        
                                        // Button
                                        if (editMode == .inactive) {
                                            Button(action: {
                                                
                                                if appState.nasabahIsExisting {
                                                    routeToPenghasilanKotor = true
                                                } else {
                                                    routeToSumberPendapatanLainnya = true
                                                }
                                                
                                            }, label:{
                                                
                                                Text("Next".localized(language))
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
                                        } else {
                                            NavigationLink(destination: RegisterSummaryView().environmentObject(registerData)) {
                                                
                                                Text("Save".localized(language))
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .font(.system(size: 14))
                                                    .frame(maxWidth: .infinity, maxHeight: 40)
                                                
                                            }
                                            .disabled(isValid())
                                            .frame(height: 50)
                                            .background(isValid() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 25)
                                        }
                                        
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
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Do you want to cancel registration?".localized(language)),
                primaryButton: .default(Text("YES".localized(language)), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text("NO".localized(language))))
        }
        .gesture(DragGesture().onEnded({ value in
            if(value.startLocation.x < 20 &&
                value.translation.width > 100) {
                self.showingAlert = true
            }
        }))
        
    }
    
    // MARK: - Form Group
    var cardForm: some View {
        
        VStack(alignment: .leading) {
            
            LabelTextField(value: $registerData.namaPenyandangDana, label: "Name of Funder".localized(language), placeHolder: "Name".localized(language)){ (changed) in
                print("on edit")
            } onCommit: {
                print("on commit")
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading) {
                
                Text("Relationship With You".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Choose relationship".localized(language), text: $registerData.hubunganPenyandangDana)
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
                                    .font(.custom("Montserrat-Regular", size: 12))
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
                
                Text("Profession Funders".localized(language))
                    .font(Font.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#707070"))
                    .multilineTextAlignment(.leading)
                
                HStack {
                    TextField("Choose a profession".localized(language), text: $registerData.profesiPenyandangDana)
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
                                    .font(.custom("Montserrat-Regular", size: 12))
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

struct FormSumberPenyandandDana2View_Previews: PreviewProvider {
    static var previews: some View {
        FormSumberPenyandandDana2View().environmentObject(RegistrasiModel())
    }
}
