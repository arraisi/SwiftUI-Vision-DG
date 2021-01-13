//
//  Term&ConditionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct Term_ConditionView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    @EnvironmentObject var appState: AppState
    
    @State var scrollPosition: CGFloat = 0.0
    
    @State var isCheckedWni: Bool = false
    @State var isCheckedAgree: Bool = false
    @State var isCheckedShareData: Bool = false
    @State var showingAlert: Bool = false
    @State var disableAgree = true
    
    @State var isShowDataVerification: Bool = false
    
    @State var readFinished = false
    @State var scrollToBottom = false
    
    func toggleIsWni() {
        isCheckedWni = !isCheckedWni
        self.disableAgree.toggle()
        self.registerData.isWni = isCheckedWni
    }
    
    func toggleIsAgree() {
        isCheckedAgree = !isCheckedAgree
        self.registerData.isAgree = isCheckedWni
        
    }
    func toggleIsShareData() {
        isCheckedShareData = !isCheckedShareData
        self.registerData.isShareData = isCheckedShareData
    }
    
    var disableForm: Bool {
        isCheckedWni && isCheckedAgree
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Color(hex: "#232175")
                    .frame(height: UIScreen.main.bounds.height*0.5)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                
                AppBarLogo(light: false, showCancel: true, onCancel: {
                    self.showingAlert = true
                })
                
                VStack {
                    Text(NSLocalizedString("SYARAT DAN KETENTUAN", comment: ""))
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        WebView(readFinished: self.$readFinished, scrollToBottom: self.$scrollToBottom, urlString: Bundle.main.url(forResource: "term", withExtension: "html")?.absoluteString)
                            .onChange(of: readFinished, perform: { value in
                                scrollToBottom = true
                            })
                            .highPriorityGesture(
                                
                                DragGesture()
                                    .onChanged({ (value) in
                                        
                                        if value.translation.height > 0 {
                                            print("\(value.translation.height) > 0")
                                            scrollToBottom = false
                                            
                                        }
                                        
                                    })
                            )
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        Spacer()
                        
                        Button(action: toggleIsWni) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedWni ? "checkmark.square": "square")
                                Text(NSLocalizedString("* Saya Adalah Warga Negara Indonesia dan tidak memiliki kewajiban pajak di Negara lain", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        .disabled(!readFinished)
                        
                        Button(action: toggleIsAgree) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedAgree ? "checkmark.square": "square")
                                Text(NSLocalizedString("* Saya setuju", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        .disabled(disableAgree)
                        
                        Button(action: toggleIsShareData) {
                            HStack(alignment: .top) {
                                Image(systemName: isCheckedShareData ? "checkmark.square": "square")
                                Text(NSLocalizedString("Saya memberikan hak kepada Bank Mestika untuk memberikan data kepada pihak ketiga yang berkerjasama dengan Bank Mestika", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        
                        NavigationLink(destination: VerificationRegisterDataView().environmentObject(registerData), isActive: self.$isShowDataVerification) {EmptyView()}
                        
                        Button(action: {
                            self.isShowDataVerification = true
                        }) {
                            Text(NSLocalizedString("Berikutnya", comment: ""))
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                        .background(Color(hex: !disableForm ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .disabled(!disableForm)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 30)
                }
                .padding(.horizontal, 30)
                .padding(.top, 35)
                .padding(.bottom, 35)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text(NSLocalizedString("Apakah ingin membatalkan registrasi ?", comment: "")),
                primaryButton: .default(Text(NSLocalizedString("YA", comment: "")), action: {
                    self.appState.moveToWelcomeView = true
                }),
                secondaryButton: .cancel(Text(NSLocalizedString("Tidak", comment: ""))))
        }
    }
}

struct Term_ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        Term_ConditionView().environmentObject(RegistrasiModel())
    }
}
