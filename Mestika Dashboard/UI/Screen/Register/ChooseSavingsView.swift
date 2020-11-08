import SwiftUI
import PopupView

struct ChooseSavingsView: View {
    /*
     Environtment Object
     */
    @EnvironmentObject var UIState: UIStateModel
    @EnvironmentObject var registerData: RegistrasiModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    /*
     Boolean for Show Modal
     */
    @State var showingModal = false

    // MARK: -MAIN CONTENT
    var body: some View {
        let spacing: CGFloat = 16
        let cardHeight: CGFloat = 200
        
        let items = [
            CardTabungan(id: 0, namaTabungan: "Tabungan A", image: "Saving Image"),
            CardTabungan(id: 1, namaTabungan: "Tabungan B", image: "Saving Image"),
        ]
        
        return ZStack {
            VStack {
                Color(hex: "#F6F8FB")
                    .frame(height: 400)
                Color(hex: "#232175")
            }
            
            VStack {
                appbar
                    .padding(.top, 45)
                    .padding(.horizontal, 30)
                
                VStack(alignment: .center) {
                    Text("Pilih Jenis Tabungan Anda")
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(hex: "#232175"))
                        .padding(.horizontal, 15)
                        .padding(.top, 20)
                        .padding(.bottom, 25)
                }
                
                VStack {
                    Canvas {
                        CarouselTabungan(
                            numberOfItems: CGFloat(items.count),
                            spacing: spacing,
                            widthOfHiddenCards: 15
                        ) {
                            ForEach(items, id: \.self.id) { item in
                                Item(
                                    _id: Int(item.id),
                                    spacing: spacing,
                                    widthOfHiddenCards: 0,
                                    cardHeight: .infinity
                                ) {
                                    VStack {
                                        Item(
                                            _id: Int(item.id),
                                            spacing: spacing,
                                            widthOfHiddenCards: 15,
                                            cardHeight: cardHeight
                                        ) {
                                            Image("\(item.image)")
                                                .resizable()
                                                .frame(width: 200, height: 160)
                                        }
                                        .cornerRadius(8)
                                        .shadow(color: Color.gray, radius: 4, x: 0, y: 4)
                                        .transition(AnyTransition.slide)
                                        .animation(.spring())
                                        
                                        VStack(alignment: .leading) {
                                            Text("Deposit Tabungan")
                                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(Color(hex: "#3756DF"))
                                                .padding(.top, 10)
                                                .padding(.horizontal, 15)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("Keunggulan Tabungan :")
                                                .font(.footnote)
                                                .padding(.top, 10)
                                                .padding(.horizontal, 15)
                                                .foregroundColor(Color(hex: "#5A6876"))
                                            
                                            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                                                HStack(alignment: .top) {
                                                    Text("01")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                                                        .font(.caption)
                                                        .foregroundColor(Color(hex: "#5A6876"))
                                                }
                                                .padding(.top, 5)
                                                .padding(.horizontal, 15)
                                                
                                                HStack(alignment: .top) {
                                                    Text("02")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                                                        .font(.caption)
                                                        .foregroundColor(Color(hex: "#5A6876"))
                                                }
                                                .padding(.top, 5)
                                                .padding(.horizontal, 15)
                                                
                                                HStack(alignment: .top) {
                                                    Text("03")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                                                        .font(.caption)
                                                        .foregroundColor(Color(hex: "#5A6876"))
                                                }
                                                .padding(.top, 5)
                                                .padding(.horizontal, 15)
                                                
                                                HStack(alignment: .top) {
                                                    Text("04")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                                                        .font(.caption)
                                                        .foregroundColor(Color(hex: "#5A6876"))
                                                }
                                                .padding(.top, 5)
                                                .padding(.horizontal, 15)
                                                
                                                HStack(alignment: .top) {
                                                    Text("05")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color(hex: "#232175"))
                                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod")
                                                        .font(.caption)
                                                        .foregroundColor(Color(hex: "#5A6876"))
                                                }
                                                .padding(.top, 5)
                                                .padding(.horizontal, 15)
                                            }
                                            
                                            Button(action: {
                                                showingModal.toggle()
                                            }) {
                                                Text("Pilih Tabungan ini")
                                                    .foregroundColor(.white)
                                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                    .font(.system(size: 13))
                                                    .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                            }
                                            .background(Color(hex: "#2334D0"))
                                            .cornerRadius(12)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 10)
                                            .padding(.top, 10)
                                            
                                        }
                                        .frame(width: UIScreen.main.bounds.width - 40)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(radius: 30)
                                    }
                                    .cornerRadius(8)
                                    .shadow(color: Color.gray, radius: 4, x: 0, y: 4)
                                    .transition(AnyTransition.slide)
                                    .animation(.spring())
                                }
                            }
                        }
                    }
                    
                }
                
                if self.showingModal {
                    ModalOverlay(tapAction: { withAnimation { self.showingModal = false } })
                }
            }
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .navigationBarHidden(true)
        .popup(isPresented: $showingModal, type: .floater(), position: .bottom, animation: Animation.spring(), closeOnTapOutside: true) {
            createBottomFloater()
        }
    }
    
    var appbar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color(hex: "#232175"))
            }
            Spacer()
            logo
            Spacer()
        }
    }
    
    var logo: some View {
        HStack(alignment: .center, spacing: .none) {
            Image("Logo M")
                .resizable()
                .frame(width: 25, height: 25)
            Text("BANK MESTIKA")
                .foregroundColor(Color(hex: "#232175"))
                .font(.system(size: 20))
                .bold()
        }
    }
    
    // MARK: -Function Create Bottom Loader
    private func createBottomFloater() -> some View {
        SavingSelectionModalView()
            .environmentObject(registerData)
            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height - 100)
            .background(Color(.white))
            .cornerRadius(50)
            .shadow(radius: 60)
    }
}

struct CardTabungan: Decodable, Hashable, Identifiable {
    var id: Int
    var namaTabungan: String = ""
    var image: String = ""
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}

struct CarouselTabungan<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @ObservedObject var UIState =  UIStateModel()
    
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return VStack(alignment: .center) {
            HStack {
                items
            }
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            
            if (value.translation.width < -50) {
                self.UIState.activeCard = self.UIState.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) {
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, alignment: .center)
            .padding(.bottom, 20)
    }
}

struct Item<Content: View>: View {
    @ObservedObject var UIState = UIStateModel()
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: Int
    var content: Content
    
    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        print("\(_id)")
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2) //279
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth, height: cardHeight, alignment: .center)
    }
}

struct ChooseSavingsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSavingsView().environmentObject(RegistrasiModel())
    }
}
