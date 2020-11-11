//
//  RegisterView.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 23/09/20.
//

import SwiftUI
import PopupView
import SystemConfiguration

var data = [
    ImageCarousel(
        id: 0,
        title: "Nikmati Kemudahan Disetiap",
        desc: "Start an entirely new payment era with smart wallet",
        image: "Slider"
    ),
    ImageCarousel(
        id: 0,
        title: "Nikmati Kemudahan Disetiap Transaksi",
        desc: "Start an entirely new payment era with smart wallet",
        image: "Slider"
    )
]

struct RegisterView: View {
    
    /* For Check Internet Connection */
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.aple.com")
    
    @State var isActive : Bool = false
    @State var isActiveRoot : Bool = false
    @ObservedObject var assetsSliderVM = SliderAssetsSummaryViewModel()
    
    var registerData = RegistrasiModel()
    
    @FetchRequest(entity: User.entity(), sortDescriptors: [])
    var user: FetchedResults<User>
    @State var isViewActivity: Bool = false
    
    /* Boolean for Show Modal & Alert */
    @State var showingModal = false
    @State var showAlert = false
    
    /* Variable for Image Carousel */
    @State var menu = 0
    @State var page = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#232175")
            
            VStack(alignment: .leading) {
                header
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                
                imageSlider
                
                footerBtn
                    .padding(.top, 20)
                    .padding(.bottom, 35)
                    .padding(.horizontal, 30)
            }
            
            if self.showingModal {
                ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
            }
        }
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Welcome to")
                .fontWeight(.semibold)
                .font(.system(size: 15))
                .foregroundColor(.white)
            
            HStack(alignment: .center, spacing: .none) {
                Image("logo_m_mestika")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                Text("BANK MESTIKA")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .fontWeight(.heavy)
                
            }.padding(.top, -5)
        }.padding(.top, 30)
    }
    
    var imageSlider: some View {
        GeometryReader{g in
            Carousel(width: UIScreen.main.bounds.width, page: self.$page, height: UIScreen.main.bounds.height - 300)
        }
    }
    
    var footerBtn: some View {
        VStack {
            Button(action : {
                showingModal.toggle()
            }) {
                Text("DAFTAR")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            NavigationLink(destination: LoginScreen()) {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .cornerRadius(12)
        }
    }
    
    // MARK: -Create Bottom Floater (Modal)
    func createBottomFloater() -> some View {
        VStack(alignment: .leading) {
            Image("ic_bells")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Sebelum Memulai..!!")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 20)
            
            Text("Apakah Anda telah memiliki rekening di Bank Mestika")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 22))
                .foregroundColor(Color(hex: "#232175"))
                .padding(.bottom, 30)
            
            NavigationLink(destination: RegisterProvisionView(rootIsActive: self.$isActive).environmentObject(registerData)) {
                Text("Tidak, Saya Tidak Memiliki")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.bottom, 2)
            .background(Color(hex: "#2334D0"))
            .cornerRadius(12)
            
            Button(action: {}) {
                Text("Ya, Saya Memiliki")
                    .foregroundColor(.black)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, maxHeight: 40)
            }
            .padding(.bottom, 30)
            .cornerRadius(12)
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .padding(.horizontal, 15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

struct ListCarousel : View {
    
    @Binding var page : Int
    var body: some View{
        HStack(spacing: 0){
            ForEach(data){ i in
                CardRegisterCarousel(page: self.$page, width: UIScreen.main.bounds.width, data: i)
            }
        }
    }
}

struct CardRegisterCarousel : View {
    
    @Binding var page : Int
    var width : CGFloat
    var data : ImageCarousel
    
    var body: some View{
        VStack{
            VStack{
                Image(self.data.image)
                    .resizable()
                
                Text(self.data.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(self.data.desc)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top, 5)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                PageControl(page: self.$page)
                    .padding([.top], 10)
            }
            .background(Color(hex: "#2334D0"))
            .cornerRadius(50)
            .padding(.top, 25)
        }
        .padding(.horizontal, 30)
        .frame(width: self.width)
        .animation(.default)
    }
}

struct Carousel : UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Carousel.Coordinator(parent1: self)
    }
    
    var width : CGFloat
    @Binding var page : Int
    var height : CGFloat
    
    func makeUIView(context: Context) -> UIScrollView{
        let total = width * CGFloat(data.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        //1.0  For Disabling Vertical Scroll....
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        
        let view1 = UIHostingController(rootView: ListCarousel(page: self.$page))
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        
        view.addSubview(view1.view)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {}
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        var parent : Carousel
        init(parent1: Carousel) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            self.parent.page = page
        }
    }
}

struct PageControl : UIViewRepresentable {
    
    @Binding var page : Int
    func makeUIView(context: Context) -> UIPageControl {
        
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = data.count
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        DispatchQueue.main.async {
            uiView.currentPage = self.page
        }
    }
}

struct ImageCarousel : Identifiable {
    var id : Int
    var title : String
    var desc : String
    var image : String
}
