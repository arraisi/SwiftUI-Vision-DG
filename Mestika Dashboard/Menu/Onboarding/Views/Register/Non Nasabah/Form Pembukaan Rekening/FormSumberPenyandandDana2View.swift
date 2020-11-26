//
//  FormSumberPenyandandDana2View.swift
//  Mestika Dashboard
//
//  Created by Abdul R. Arraisi on 18/11/20.
//

import SwiftUI

struct FormSumberPenyandandDana2View: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let sumberPenyandangDana: [MasterModel] = load("sumberPenyandangDana.json")
    @State var hubunganId : Int = 0
    @State var profesiPenyandangDanaId : Int = 0
    
    var body: some View {
        ZStack{
            Color(hex: "#232175")
            
            VStack {
                
                Spacer()
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 45 / 100 * UIScreen.main.bounds.height)
                    .cornerRadius(radius: 25.0, corners: .topLeft)
                    .cornerRadius(radius: 25.0, corners: .topRight)
            }
            
            VStack {
                
                CustomNavigationBarView(presentationMode: _presentationMode)
                    .padding(.top, 45)
                    .padding(.horizontal, 30)
                
                ScrollView {
                    
                    // Title
                    Text("DATA PEMBUKAAN REKENING")
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .padding(.vertical, 45)
                        .padding(.horizontal, 40)
                    
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
                                Text("Sumber Penyandang Dana - 02")
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
                                NavigationLink(destination: InformasiPerusahaanView().environmentObject(registerData), label:{
                                    
                                    Text("Berikutnya")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                    
                                })
                                .disabled(isValid())
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
                .padding(.bottom, 0.1)
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
                
                TextFieldWithPickerAsInput(data: ["Ayah", "Ibu", "Kaka", "Adik", "Saudara", "Teman"], placeholder: "Pilih hubungan", selectionIndex: $hubunganId, text: $registerData.hubunganPenyandangDana)
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
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
                
                TextFieldWithPickerAsInput(data: ["Pegawai Swasta", "Pegawai Negeri", "Pegawai BUMN/BUMD", "Wirausaha"], placeholder: "Pilih profesi", selectionIndex: $profesiPenyandangDanaId, text: $registerData.profesiPenyandangDana)
                    .frame(height: 36)
                    .font(Font.system(size: 14))
                    .padding(.horizontal)
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
        FormSumberPenyandandDana2View()
    }
}
