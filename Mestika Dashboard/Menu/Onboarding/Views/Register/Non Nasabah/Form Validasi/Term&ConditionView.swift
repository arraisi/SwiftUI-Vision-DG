//
//  Term&ConditionView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 30/09/20.
//

import SwiftUI

struct Term_ConditionView: View {
    @EnvironmentObject var registerData: RegistrasiModel
    
    @State var scrollPosition: CGFloat = 0.0
    
    @State var isChecked:Bool = false
    @State var isChecked1:Bool = false
    @State var isChecked2:Bool = false
    
    func toggle() {
        isChecked = !isChecked
        scrollPosition = 0.3
    }
    
    func toggle1() {
        isChecked1 = !isChecked1
        scrollPosition = 1
    }
    func toggle2() { isChecked2 = !isChecked2 }
    
    var disableForm: Bool {
        isChecked && isChecked2
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            VStack {
                Color(hex: "#232175")
                    .frame(height: 300)
                Color(hex: "#F6F8FB")
            }
            
            VStack {
                VStack {
                    Text("SYARAT DAN KETENTUAN")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading) {
                        ScrollView {
                            ScrollViewReader { scrollProxy in
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas pretium sollicitudin ex. Nulla faucibus tellus sed est auctor volutpat. Integer sollicitudin, nisi quis luctus malesuada, quam tortor elementum ligula, ut interdum leo turpis id mi. Vivamus nec consequat nibh. Cras augue ligula, vulputate id est in, suscipit convallis ligula. Duis porta, lorem id pharetra rutrum, neque metus eleifend tellus, et interdum odio dui ut lorem. Nunc elementum erat magna, eget lobortis mi venenatis sit amet. Ut vitae dictum odio. Quisque convallis enim eros, non sagittis nunc pulvinar ac. In vel malesuada dui, vel posuere lacus. Donec tempus libero ac augue lacinia convallis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas pretium sollicitudin ex. Nulla faucibus tellus sed est auctor volutpat. Integer sollicitudin, nisi quis luctus malesuada, quam tortor elementum ligula, ut interdum leo turpis id mi. Vivamus nec consequat nibh. Cras augue ligula, vulputate id est in, suscipit convallis ligula. Duis porta, lorem id pharetra rutrum, neque metus eleifend tellus, et interdum odio dui ut lorem. Nunc elementum erat magna, eget lobortis mi venenatis sit amet. Ut vitae dictum odio. Quisque convallis enim eros, non sagittis nunc pulvinar ac. In vel malesuada dui, vel posuere lacus. Donec tempus libero ac augue lacinia convallis.")
                                    .id("text")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#707070"))
                                    .multilineTextAlignment(.leading)
                                    .padding(.top, 20)
                                    .padding(.horizontal, 20)
                                    .onChange(of: scrollPosition) { newScrollPosition in
                                        scrollProxy.scrollTo("text")
                                    }
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        Spacer()
                        
                        Button(action: toggle) {
                            HStack(alignment: .top) {
                                Image(systemName: isChecked ? "checkmark.square": "square")
                                Text("* Saya Adalah Warga Negara Indonesia dan tidak memiliki kewajiban pajak di Negara lain")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        
                        Button(action: toggle1) {
                            HStack(alignment: .top) {
                                Image(systemName: isChecked1 ? "checkmark.square": "square")
                                Text("* Saya Adalah Warga Negara Indonesia dan tidak memiliki kewajiban pajak di Negara lain")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                        }
                        
                        Button(action: toggle2) {
                            HStack(alignment: .top) {
                                Image(systemName: isChecked2 ? "checkmark.square": "square")
                                Text("* Saya Adalah Warga Negara Indonesia dan tidak memiliki kewajiban pajak di Negara lain")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#707070"))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        
                        NavigationLink(destination: VerificationRegisterDataView().environmentObject(registerData)) {
                            Text("Berikutnya")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .font(.system(size: 13))
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                        }
                        .background(Color(hex: !isChecked ? "#CBD1D9" : "#2334D0"))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .disabled(!isChecked)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 500)
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
        .navigationBarTitle("BANK MESTIKA", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct Term_ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        Term_ConditionView().environmentObject(RegistrasiModel())
    }
}
