//
//  FormPenghasilanKotorView.swift
//  Bank Mestika
//
//  Created by Abdul R. Arraisi on 30/09/20.
//

import SwiftUI

struct PenghasilanKotorView: View {
    
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let penghasilanKotor: [MasterModel] = load("penghasilanKotor.json")
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
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
                ScrollView {
                    
                    // Title
                    Text("DATA PEMBUKAAN REKENING")
                        .font(.custom("Montserrat-ExtraBold", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
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
                                Text("Berapa Penghasilan Kotor Anda")
                                    .font(.custom("Montserrat-SemiBold", size: 18))
                                    .foregroundColor(Color(hex: "#232175"))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 30)
                                
                                // Forms input
                                ZStack {
                                    
                                    RadioButtonGroup(
                                        items: penghasilanKotor,
                                        selectedId: $registerData.penghasilanKotorId) { selected in
                                        
                                        if let i = penghasilanKotor.firstIndex(where: { $0.id == selected }) {
                                            print(penghasilanKotor[i])
                                            registerData.penghasilanKotor = penghasilanKotor[i].name
                                        }
                                        
                                        print("Selected is: \(registerData.penghasilanKotor)")
                                    }
                                    .padding()
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                
                                // Button
                                NavigationLink(destination: SumberPendapatanLainnyaView().environmentObject(registerData), label:{
                                    
                                    Text("Berikutnya")
                                        .foregroundColor(.white)
                                        .font(.custom("Montserrat-SemiBold", size: 14))
                                        .frame(maxWidth: .infinity, maxHeight: 40)
                                    
                                })
                                .disabled(registerData.penghasilanKotorId == 0)
                                .frame(height: 50)
                                .background(registerData.penghasilanKotorId == 0 ? Color(.lightGray) : Color(hex: "#2334D0"))
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [.white, Color(hex: "#D6DAF0")]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(25.0)
                            .shadow(color: Color(hex: "#2334D0").opacity(0.2), radius: 5, y: -2)
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
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
    }
}


struct FormPenghasilanKotorView_Previews: PreviewProvider {
    static var previews: some View {
        PenghasilanKotorView().environmentObject(RegistrasiModel())
    }
}
