//
//  VerificationRegisterDataView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 01/10/20.
//

import SwiftUI

struct VerificationRegisterDataView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State var image: Image? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var nextRoute: Bool = false
    @State private var backToEditKTP: Bool = false
    
    @ObservedObject private var userRegisterVM = UserRegistrationViewModel()
    
    /* GET DEVICE ID */
    var deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    /* CORE DATA */
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    
    @State private var showingAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#232175")
            
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .frame(height: UIScreen.main.bounds.height / 2.2)
                
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: true) {
                    self.appState.moveToWelcomeView = true
                }
                
                ScrollView {
                    VStack {
                        Text("PASTIKAN INFORMASI ANDA BENAR")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 20)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .leading) {
                            Group {
                                LabelTextFieldWithIcon(value: $registerData.nik, label: "KTP", placeHolder: "KTP") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 20)
                                .padding(.horizontal, 20)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                                LabelTextFieldWithIcon(value: $registerData.noTelepon, label: "No. Telepon", placeHolder: "No. Telepon") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                
                                LabelTextFieldWithIcon(value: $registerData.email, label: "Email", placeHolder: "Email") {
                                    (Bool) in
                                    print("on edit")
                                } onCommit: {
                                    print("on commit")
                                }.padding(.top, 10)
                                .padding(.horizontal, 20)
                                .disabled(true)
                                
                                NavigationLink(
                                    destination: FormIdentitasDiriView(editMode: .active).environmentObject(registerData),
                                    isActive: self.$backToEditKTP,
                                    label: {
                                        EmptyView()
                                    })
                                
                                VStack {
                                    
                                    Button(action: {
                                        self.backToEditKTP = true
                                    }) {
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
                                        
                                    }
                                    
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                VStack {
                                    
                                    Button(action: {
                                        
                                    }) {
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
                                    }
                                    Divider()
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 20)
                                
                                VStack {
                                    
                                    Button(action: {
                                        
                                    }) {
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
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: TujuanPembukaanRekeningView(editMode: .active).environmentObject(registerData)) {
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
                                        
                                        NavigationLink(destination: SumberDanaView(editMode: .active).environmentObject(registerData)) {
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
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: PerkiraanPenarikanView(editMode: .active).environmentObject(registerData)) {
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
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: BesarPerkiraanPenarikanView(editMode: .active).environmentObject(registerData)) {
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
                                        
                                        NavigationLink(destination: PerkiraanSetoranView(editMode: .active).environmentObject(registerData)) {
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
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: BesarPerkiraanSetoranView(editMode: .active).environmentObject(registerData)) {
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
                                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        
                                        Divider()
                                            .frame(height: 30)
                                        
                                        NavigationLink(destination: PerkerjaanView(editMode: .active).environmentObject(registerData)) {
                                            Text("Edit").foregroundColor(.blue)
                                        }
                                    }
                                    .frame(height: 20)
                                    .font(.subheadline)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 20)
                                    
                                    dynamicForm
                                    
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: UIScreen.main.bounds.width - 30, maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 30)
                    }
                    .padding(.horizontal, 30)
                    //                    .padding(.top, 90)
                    .padding(.bottom, 35)
                }
                
                VStack {
                    Button(action: {
                        
                        //                        saveUserToCoreData()
                        saveUserToDb()
                        
                    }, label: {
                        Text("Submit Data")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                    })
                    .background(Color(hex: "#2334D0"))
                    .cornerRadius(12)
                    .padding(.horizontal, 100)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .disabled(self.userRegisterVM.isLoading)
                    
                    NavigationLink(
                        destination: SuccessRegisterView().environmentObject(registerData),
                        isActive: self.$nextRoute,
                        label: {}
                    )
                }
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        //        .navigationBarItems(
        //            trailing: LoadingIndicator(style: .medium, animate: .constant(self.userRegisterVM.isLoading))
        //                .configure {
        //                    $0.color = .white
        //                })
        //        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Message"),
                message: Text("\(self.userRegisterVM.message)"),
                dismissButton: .default(Text("Oke")))
        }
        
    }
    
    var dynamicForm: some View {
        VStack(alignment: .leading) {
            
            // MARK : Pekerjaan BUMN
            if [6 ,9, 10, 11, 12].contains(registerData.pekerjaanId) {
                
                // MARK : Pekerjaan Pensiunan, Pelajar, IRT
                if (registerData.pekerjaanId == 10 || registerData.pekerjaanId == 11 || registerData.pekerjaanId == 12) {
                    EmptyView()
                } else {
                    Text("Penghasilan Kotor")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Penghasilan Kotor", text: $registerData.penghasilanKotor)
                            .disabled(true)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: PenghasilanKotorView(editMode: .active).environmentObject(registerData)) {
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
                
                if registerData.pekerjaanId == 6 {
                    Text("Jabatan")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Jabatan", text: $registerData.jabatanProfesi)
                            .disabled(true)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: FormJabatanProfesiView(editMode: .active).environmentObject(registerData)) {
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
                
                // MARK : Pekerjaan Wiraswasta
                if registerData.pekerjaanId == 9 {
                    Text("Industri")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Industri", text: $registerData.industriTempatBekerja)
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
                        Divider()
                            .frame(height: 30)
                        
                        NavigationLink(destination: FormIndustriTempatBekerjaView(editMode: .active).environmentObject(registerData)) {
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
            }
            
            Text("Sumber Pendapatan Lainnya")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            
            HStack {
                TextField("Sumber Pendapatan Lainnya", text: $registerData.sumberPendapatanLainnya)
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: SumberPendapatanLainnyaView(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // MARK : Pekerjaan Wiraswasta
            if [10, 11, 12].contains(registerData.pekerjaanId) {
                informasiPenyandangDanaFields
            } else {
                informasiPerusahaanFields
            }
            
            informasiKeluargaFields
        }
    }
    
    var informasiPenyandangDanaFields: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Informasi Penyandang Dana")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: FormSumberPenyandandDana2View(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text("Nama Penyandang Dana")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama Penyandang Dana", text: $registerData.namaPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Hubungan Dengan Anda")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Hubungan Dengan Anda", text: $registerData.hubunganPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Profesi Penyandang Dana")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Profesi Penyandang Dana", text: $registerData.profesiPenyandangDana)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
        }
        .padding(.bottom, 5)
    }
    
    var informasiPerusahaanFields: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Informasi Perusahaan")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: InformasiPerusahaanView(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text("Nama Perusahaan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama Perusahaan", text: $registerData.namaPerusahaan)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Bidang Usaha")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Bidang Usaha", text: $registerData.bidangUsaha)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Alamat Perusahaan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Alamat Perusahaan", text: $registerData.alamatPerusahaan)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kode Pos")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kode Pos", text: $registerData.kodePos)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kecamatan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kecamatan", text: $registerData.kecamatan)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kelurahan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kelurahan", text: $registerData.kelurahan)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Nomor Telepon")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nomor Telepon", text: $registerData.noTeleponPerusahaan)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 5)
    }
    
    var informasiKeluargaFields: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Keluarga Terdekat Anda")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .frame(height: 30)
                
                NavigationLink(destination: KeluargaTerdekat(editMode: .active).environmentObject(registerData)) {
                    Text("Edit").foregroundColor(.blue)
                }
            }
            .frame(height: 20)
            .font(.subheadline)
            .padding()
            .cornerRadius(15)
            
            Group {
                Text("Hubungan Dengan Anda")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Hubungan Dengan Anda", text: $registerData.hubunganKekerabatanKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Nama")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nama", text: $registerData.namaKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Alamat")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Alamat Perusahaan", text: $registerData.alamatKeluarga)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kode Pos")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kode Pos", text: $registerData.kodePosKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kecamatan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kecamatan", text: $registerData.kecamatanKeluarga)
                        .disabled(true)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Kelurahan")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Kelurahan", text: $registerData.kelurahanKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
            Group {
                Text("Nomor Telepon")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                HStack {
                    TextField("Nomor Telepon", text: $registerData.noTlpKeluarga)
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
                .frame(height: 20)
                .font(.subheadline)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
            }
            
        }
        .padding(.bottom, 20)
    }
    
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
            //
            //            let data = User(context: managedObjectContext)
            //            data.deviceId = UIDevice.current.identifierForVendor?.uuidString
            //            data.nik = self.registerData.nik
            //            data.email = self.registerData.email
            //            data.phone = self.registerData.noTelepon
            //            data.pin = self.registerData.pin
            //            data.password = self.registerData.password
            //            data.firstName = "Stevia"
            //            data.lastName = "R"
            //            data.email = self.registerData.email
            //
            //            UserDefaults.standard.set("true", forKey: "isFirstLogin")
            
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
        //        nextRoute = true
        
        //        self.registerData.nik = "5106040309800927"
        //        self.registerData.namaLengkapFromNik = "DATA TEST T 03"
        //        self.registerData.tempatLahirFromNik = "LAHIR"
        //        self.registerData.alamatKtpFromNik = "JL PROF DR LATUMETEN I GG.5/6"
        //        self.registerData.rtFromNik = "02"
        //        self.registerData.rwFromNik = "03"
        //        self.registerData.kelurahanFromNik = "ANDIR"
        //        self.registerData.kecamatanFromNik = "ANDIR"
        //        self.registerData.kabupatenKotaFromNik = "ANDIR"
        //        self.registerData.provinsiFromNik = "JAWA BARAT"
        
        self.userRegisterVM.userRegistration(registerData: registerData) { success in
            if success {
                nextRoute = true
            }
            
            if !success {
                self.showingAlert = true
            }
        }
    }
}

struct VerificationRegisterDataView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationRegisterDataView().environmentObject(RegistrasiModel())
    }
}
