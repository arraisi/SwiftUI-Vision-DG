//
//  AccountTabs.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 21/10/20.
//

import SwiftUI

struct AccountTabs: View {
    
    @EnvironmentObject var appState: AppState
    
    /* CORE DATA */
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: NewDevice.entity(), sortDescriptors: []) var device: FetchedResults<NewDevice>
    
    @Binding var showingSettingMenu : Bool
    @State var username: String = ""
    @State var phoneNumber: String = ""
    
    /* Data Binding */
    @ObservedObject private var authVM = AuthViewModel()
    @State private var isFingerprint = false
    @State private var isNextRoute = false
    
    /* CORE DATA */
    @FetchRequest(entity: Registration.entity(), sortDescriptors: [])
    var user: FetchedResults<Registration>
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                GeometryReader { geometry in
                    Color.clear.preference(key: OffsetKey.self, value: geometry.frame(in: .global).minY)
                        .frame(height: 0)
                }
                
                ZStack {
                    VStack {
                        profileInfo
                        menuGrid
                            .padding(.bottom)
                    }
                }
            })
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            if let value = device.last?.fingerprintFlag {
                print("CORE DATA - Finger Print = \(value)")
                self.isFingerprint = value
            }
        })
    }
    
    var profileInfo: some View {
        VStack {
            HStack(alignment: .center) {
                Image("foryou-card-1")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("\(self.username)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#2334D0"))
                    
                    Text("+62\(self.phoneNumber)")
                        .font(.caption)
                        .fontWeight(.light)
                }
                
                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
    }
    
    // MARK: -MENU GRID VIEW
    var menuGrid: some View {
        VStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Account")
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Personal Data")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Address")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Contact")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Language")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                }
                .frame(width: UIScreen.main.bounds.width - 30)
            }
            
            ZStack {
                VStack {
                    HStack {
                        Text("Security")
                            .foregroundColor(Color(hex: "#232175"))
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Toggle(
                                isOn: $isFingerprint,
                                label: {
                                    Text("Aktifasi Fingerprint")
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                            )
                            .onChange(of: self.isFingerprint) { value in
                                //perform your action here...
                                saveDataNewDeviceToCoreData()
                                
                                if value {
                                    
                                    self.authVM.setFingerPrint { result in
                                        print("result : \(result)")
                                        if result {
                                            print("SET FINGER PRINT SUCCESS")
                                        }
                                        
                                        if !result {
                                            print("SET FINGER PRINT")
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Change Password")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Change PIN Transaction")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Forgot Pin Transaction")
                                .foregroundColor(Color(hex: "#1D2238"))
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 10)
                    
                    Button(
                        action: {
                            self.authVM.postLogout { success in
                                if success {
                                    print("SUCCESS LOGOUT")
                                    self.appState.moveToWelcomeView = true
                                    //                                    self.isNextRoute = true
                                }
                            }
                        },
                        label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Logout")
                                        .foregroundColor(Color(hex: "#1D2238"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 15)
                        }
                    )
                }
                .frame(width: UIScreen.main.bounds.width - 30)
            }
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.3), radius: 10)
        .onAppear {
            getProfile()
            getUserInfo()
        }
        
    }
    
    /* Function GET USER Status */
    @ObservedObject var profileVM = ProfileViewModel()
    func getProfile() {
        self.profileVM.getProfile { success in
            if success {
                print("Name \(self.profileVM.name)")
                print(self.profileVM.balance)
                self.username = self.profileVM.name
                self.phoneNumber = self.profileVM.telepon
            }
        }
    }
    
    func getUserInfo() {
        self.user.forEach { (data) in
            self.username = data.namaLengkapFromNik!
            self.phoneNumber = data.noTelepon!
        }
    }
    
    func saveDataNewDeviceToCoreData()  {
        print("------SAVE TO CORE DATA-------")
        
        let data = NewDevice(context: managedObjectContext)
        data.fingerprintFlag = self.isFingerprint
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
    }
}

struct AccountTabs_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabs(showingSettingMenu: .constant(false))
    }
}
