//
//  GridMenuAllPaymentPurchaseView.swift
//  Mestika Dashboard
//
//  Created by Prima Jatnika on 04/11/20.
//

import SwiftUI

struct GridMenuAllPaymentPurchaseView: View {
    
    let gridItems = [
        GridItem(.fixed(80), spacing: 20),
        GridItem(.fixed(80), spacing: 20),
        GridItem(.fixed(80), spacing: 20),
        GridItem(.fixed(80), spacing: 20),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("All payment & purchase")
                    .font(.title3)
                    .fontWeight(.ultraLight)
                
                Spacer()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("See All category")
                        .bold()
                        .foregroundColor(Color(hex: "#2334D0"))
                })
            }
            .padding([.leading, .trailing], 15)
            
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 20) {
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("PLN")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("PDAM")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Telkom")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("BPJS")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Top Up")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Mobile & Data")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("TV & Internet")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Credit Card")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Transport")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                
                VStack {
                    Button(action: {}, label: {
                        VStack {
                            EmptyView()
                        }
                        .frame(width: 55, height: 55)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.3), radius: 10)
                    })
                    
                    Text("Train")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
            }
        }
    }
}

struct GridMenuAllPaymentPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        GridMenuAllPaymentPurchaseView()
    }
}
