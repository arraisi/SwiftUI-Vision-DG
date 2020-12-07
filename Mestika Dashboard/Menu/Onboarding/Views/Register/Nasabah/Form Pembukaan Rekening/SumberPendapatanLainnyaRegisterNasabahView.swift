//
//  FormSumberPendapatanLainnyaScreen.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 11/11/20.
//

import SwiftUI

struct SumberPendapatanLainnyaRegisterNasabahView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var sumberPendapatanLain = ""
    
    @State var selectedId = 0
    @State var selection: String?
    
    @State var sumberPendapatanLainIndex = 0
    @State var isShowingKeluargaTerdekat = false
    
    let sumberPendapatanLainnyaList = ["Online Shop", "Cathering", "Laundry pakaian", "Sosial media buzzer", "Jual aneka kue", "Lainnya"]
    let sumberPendapatanLainnya: [MasterModel] = load("sumberPendapatanLainnya.json")
    
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
                        
                        VStack {
                            
                            // Title
                            Text("DATA PEMBUKAAN REKENING")
                                .font(.custom("Montserrat-ExtraBold", size: 24))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 25)
                                .padding(.horizontal, 40)
                            
                            // Content
                            ZStack {
                                
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
                                        Text("Apakah Anda Memiliki Sumber Pendapatan Lainnya")
                                            .font(.custom("Montserrat-SemiBold", size: 18))
                                            .foregroundColor(Color(hex: "#232175"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 40)
                                            .padding(.vertical, 30)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // Forms input
                                        ZStack {
                                            
                                            VStack {
                                                
                                                Button(action:{
                                                    
                                                    self.selectedId = 1
                                                    
                                                }) {
                                                    
                                                    HStack(alignment: .center, spacing: 10) {
                                                        
                                                        Image(systemName: self.selectedId == 1 ? "largecircle.fill.circle" : "circle")
                                                            //                    .renderingMode(.original)
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 19, height: 19)
                                                        
                                                        Text("Ya, Saya memiliki")
                                                            .font(.custom("Montserrat-Regular", size: 10))
                                                        
                                                        Spacer()
                                                        
                                                    }
                                                    .foregroundColor(Color.black.opacity(0.6))
                                                }
                                                
                                                if self.selectedId == 1 {
                                                    //                                            VStack(alignment: .leading) {
                                                    //                                                TextFieldWithPickerAsInput(data: ["Online Shop", "Cathering", "Laundry pakaian", "Sosial media buzzer", "Jual aneka kue", "Lainnya"], placeholder: "Pilih pendapatan lainnya", selectionIndex:$sumberPendapatanLainIndex, text: $registerData.sumberPendapatanLain)
                                                    //                                                    .frame(height: 36)
                                                    //                                                    .font(Font.system(size: 14))
                                                    //                                                    .padding(.horizontal)
                                                    //                                                    .background(Color.gray.opacity(0.1))
                                                    //                                                    .cornerRadius(10)
                                                    //
                                                    //                                            }
                                                    //                                            .padding(.horizontal, 20)
                                                    
                                                    
                                                    HStack {
                                                        TextField("Pilih pendapatan lainnya", text: $registerData.sumberPendapatanLainnya)
                                                            .font(.custom("Montserrat-Regular", size: 12))
                                                            .frame(height: 50)
                                                            .padding(.leading, 15)
                                                            .disabled(true)
                                                        
                                                        Menu {
                                                            ForEach(0..<sumberPendapatanLainnyaList.count, id: \.self) { i in
                                                                Button(action: {
                                                                    print(sumberPendapatanLainnyaList[i])
                                                                    registerData.sumberPendapatanLainnya = sumberPendapatanLainnyaList[i]
                                                                }) {
                                                                    Text(sumberPendapatanLainnyaList[i])
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
                                                    .padding(.horizontal, 20)
                                                }
                                                
                                                Button(action:{
                                                    
                                                    self.selectedId = 2
                                                    
                                                }) {
                                                    
                                                    HStack(alignment: .center, spacing: 10) {
                                                        
                                                        Image(systemName: self.selectedId == 2 ? "largecircle.fill.circle" : "circle")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 19, height: 19)
                                                        
                                                        Text("Tidak, Saya tidak memiliki")
                                                            .font(.custom("Montserrat-Regular", size: 10))
                                                        
                                                        Spacer()
                                                        
                                                    }
                                                    .foregroundColor(Color.black.opacity(0.6))
                                                }
                                            }
                                            .padding()
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 100)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                        
                                        // Button
        //                                NavigationLink(destination: FormVerificationRegisterDataNasabahScreen().environmentObject(registerData), label:{
                                        NavigationLink(destination: KeluargaTerdekatRegisterNasabahView().environmentObject(registerData), label:{
                                            
                                            Text("Berikutnya")
                                                .foregroundColor(.white)
                                                .font(.custom("Montserrat-SemiBold", size: 14))
                                                .frame(maxWidth: .infinity, maxHeight: 40)
                                            
                                        })
                                        .frame(height: 50)
                                        .background(isDisableButtonBerikutnya() ? Color(.lightGray) : Color(hex: "#2334D0"))
                                        .cornerRadius(12)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 25)
                                        .disabled(isDisableButtonBerikutnya())
                                        
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
    
    private func isDisableButtonBerikutnya() -> Bool {
        if self.selectedId == 2 || (self.selectedId == 1 && registerData.sumberPendapatanLainnya != "") {
            return false
        }
        return true
    }
}

struct SumberPendapatanLainnyaRegisterNasabahView_Previews: PreviewProvider {
    static var previews: some View {
        SumberPendapatanLainnyaRegisterNasabahView().environmentObject(RegistrasiModel())
    }
}
